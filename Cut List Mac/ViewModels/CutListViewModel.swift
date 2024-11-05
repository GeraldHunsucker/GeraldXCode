import SwiftUI
import UniformTypeIdentifiers
import PDFKit

@MainActor
class CutListViewModel: ObservableObject {
    @Published var stockMaterials: [Material] = []
    @Published var cutPieces: [CutPiece] = []
    @Published var kerfWidth: Double = 0.125
    @Published var layouts: [CutLayout] = []
    @Published var projectName: String = "Untitled Project"
    @Published var alertError: String? = nil
    
    private weak var layoutView: NSView?
    
    init() {
        // Add notification observer for layout view
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLayoutViewFound(_:)),
            name: NSNotification.Name("LayoutViewFound"),
            object: nil
        )
    }
    
    @objc private func handleLayoutViewFound(_ notification: Notification) {
        if let view = notification.object as? NSView {
            print("Layout view found via notification: \(view)")
            Task { @MainActor in
                self.layoutView = view
            }
        }
    }
    
    func addMaterial(_ material: Material) {
        print("Adding material to viewModel: \(material.name)")
        stockMaterials.append(material)
        print("Current stock materials count: \(stockMaterials.count)")
    }
    
    func updateMaterial(_ material: Material) {
        if let index = stockMaterials.firstIndex(where: { $0.id == material.id }) {
            stockMaterials[index] = material
        }
    }
    
    func deleteMaterial(_ material: Material) {
        stockMaterials.removeAll { $0.id == material.id }
    }
    
    func addCutPiece(_ piece: CutPiece) {
        cutPieces.append(piece)
    }
    
    func updateCutPiece(_ piece: CutPiece) {
        if let index = cutPieces.firstIndex(where: { $0.id == piece.id }) {
            cutPieces[index] = piece
        }
    }
    
    func deleteCutPiece(_ piece: CutPiece) {
        cutPieces.removeAll { $0.id == piece.id }
    }
    
    func optimize() {
        print("Starting optimization...")
        print("Stock materials: \(stockMaterials.count)")
        print("Cut pieces: \(cutPieces.count)")
        
        layouts.removeAll()
        
        // Expand pieces based on quantity and add sequence numbers
        var remainingPieces = cutPieces.flatMap { piece in
            (0..<piece.quantity).map { index in
                CutPiece(
                    length: piece.length,
                    width: piece.width,
                    quantity: 1,
                    label: piece.label,
                    sequenceNumber: index + 1,
                    requiredGrainDirection: piece.requiredGrainDirection
                )
            }
        }.sorted { piece1, piece2 in
            (piece1.length * piece1.width) > (piece2.length * piece2.width)
        }
        
        print("Total pieces to place: \(remainingPieces.count)")
        
        while !remainingPieces.isEmpty {
            guard let material = stockMaterials.first else {
                print("No more materials available")
                break
            }
            
            print("Processing material: \(material.name)")
            var placements: [CutLayout.Placement] = []
            var currentY: Double = 0
            let kerf = material.kerfThickness
            
            while !remainingPieces.isEmpty && currentY + kerf <= material.length {
                var currentX: Double = 0
                var rowHeight: Double = 0
                var piecesPlacedInRow = false
                
                var i = 0
                while i < remainingPieces.count {
                    let piece = remainingPieces[i]
                    var placed = false
                    
                    // Try normal orientation
                    if currentX + piece.width + kerf <= material.width &&
                       currentY + piece.length + kerf <= material.length {
                        placements.append(CutLayout.Placement(
                            piece: piece,
                            x: currentX,
                            y: currentY,
                            rotated: false
                        ))
                        currentX += piece.width + kerf
                        rowHeight = max(rowHeight, piece.length)
                        placed = true
                    }
                    // Try rotated orientation
                    else if currentX + piece.length + kerf <= material.width &&
                            currentY + piece.width + kerf <= material.length {
                        placements.append(CutLayout.Placement(
                            piece: piece,
                            x: currentX,
                            y: currentY,
                            rotated: true
                        ))
                        currentX += piece.length + kerf
                        rowHeight = max(rowHeight, piece.width)
                        placed = true
                    }
                    
                    if placed {
                        remainingPieces.remove(at: i)
                        piecesPlacedInRow = true
                    } else {
                        i += 1
                    }
                }
                
                if piecesPlacedInRow {
                    currentY += rowHeight + kerf
                } else {
                    break
                }
            }
            
            // Calculate waste percentage
            let totalArea = material.length * material.width
            let usedArea = placements.reduce(0.0) { sum, placement in
                let piece = placement.piece
                return sum + (piece.length * piece.width)
            }
            let wastePercentage = ((totalArea - usedArea) / totalArea) * 100
            
            layouts.append(CutLayout(
                material: material,
                placements: placements,
                wastePercentage: wastePercentage,
                kerfThickness: kerf
            ))
        }
        
        print("Optimization complete. Created \(layouts.count) layouts")
        if !remainingPieces.isEmpty {
            print("Warning: \(remainingPieces.count) pieces could not be placed")
        }
    }
    
    func clearAll() {
        stockMaterials.removeAll()
        cutPieces.removeAll()
        layouts.removeAll()
    }
    
    func setLayoutView(_ view: NSView) {
        layoutView = view
        print("Layout view reference stored: \(view)")
    }
    
    func exportPDF() {
        // Configure save panel first
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.pdf]
        savePanel.nameFieldStringValue = "\(projectName).pdf"
        
        // Show save panel
        guard savePanel.runModal() == .OK,
              let url = savePanel.url else { return }
        
        // Calculate size
        let size = CGSize(
            width: max(842, self.layouts.reduce(0) { maxWidth, layout in
                max(maxWidth, layout.material.width * 4 + 100)
            }),
            height: max(595, self.layouts.reduce(0) { totalHeight, layout in
                totalHeight + (layout.material.length * 4 + 200)
            })
        )
        
        // Create printable content using our dedicated PrintableView
        let contentView = PrintableView(layouts: self.layouts)
            .frame(width: size.width, height: size.height)
        
        // Create hosting view
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = CGRect(origin: .zero, size: size)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.white.cgColor
        
        // Give time for SwiftUI to render
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Configure print info
            let printInfo = NSPrintInfo.shared
            printInfo.topMargin = 0
            printInfo.bottomMargin = 0
            printInfo.leftMargin = 0
            printInfo.rightMargin = 0
            printInfo.horizontalPagination = .fit
            printInfo.verticalPagination = .fit
            printInfo.orientation = .landscape
            printInfo.paperSize = size
            
            // Create bitmap representation
            let imageRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
            hostingView.cacheDisplay(in: hostingView.bounds, to: imageRep)
            
            // Create PDF data
            let pdfData = NSMutableData()
            var mediaBox = CGRect(origin: .zero, size: size)
            
            guard let context = CGContext(consumer: CGDataConsumer(data: pdfData)!,
                                        mediaBox: &mediaBox,
                                        nil) else { return }
            
            // Begin PDF page
            context.beginPage(mediaBox: &mediaBox)
            
            // Fill white background
            context.setFillColor(NSColor.white.cgColor)
            context.fill(mediaBox)
            
            // Draw the image
            if let cgImage = imageRep.cgImage {
                context.draw(cgImage, in: mediaBox)
            }
            
            // End PDF page and context
            context.endPage()
            context.closePDF()
            
            // Write to file
            try? pdfData.write(to: url, options: .atomic)
        }
    }
    
    func printLayout() {
        // Calculate size
        let size = CGSize(
            width: max(842, self.layouts.reduce(0) { maxWidth, layout in
                max(maxWidth, layout.material.width * 4 + 100)
            }),
            height: max(595, self.layouts.reduce(0) { totalHeight, layout in
                totalHeight + (layout.material.length * 4 + 200)
            })
        )
        
        // Create printable content using our dedicated PrintableView
        let contentView = PrintableView(layouts: self.layouts)
            .frame(width: size.width, height: size.height)
        
        // Create hosting view
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = CGRect(origin: .zero, size: size)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.white.cgColor
        
        // Give time for SwiftUI to render
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Configure print info
            let printInfo = NSPrintInfo.shared
            printInfo.topMargin = 0
            printInfo.bottomMargin = 0
            printInfo.leftMargin = 0
            printInfo.rightMargin = 0
            printInfo.horizontalPagination = .fit
            printInfo.verticalPagination = .fit
            printInfo.orientation = .landscape
            printInfo.paperSize = size
            
            // Create bitmap representation
            let imageRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
            hostingView.cacheDisplay(in: hostingView.bounds, to: imageRep)
            
            // Create an NSImageView for printing
            let imageView = NSImageView(frame: hostingView.bounds)
            let image = NSImage(size: hostingView.bounds.size)
            image.addRepresentation(imageRep)
            imageView.image = image
            
            // Create print operation
            let printOperation = NSPrintOperation(view: imageView, printInfo: printInfo)
            printOperation.showsPrintPanel = true
            printOperation.showsProgressPanel = true
            printOperation.jobTitle = self.projectName
            
            // Run operation
            printOperation.run()
        }
    }
    
    func saveProject() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.json]
        savePanel.nameFieldStringValue = "\(projectName).json"
        
        if savePanel.runModal() == .OK {
            guard let url = savePanel.url else { return }
            
            let project = Project(
                name: projectName,
                materials: stockMaterials,
                cutPieces: cutPieces,
                layouts: layouts,
                dateModified: Date()
            )
            
            try? ProjectManager.shared.saveProject(project, to: url)
        }
    }
    
    func loadProject() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.json]
        openPanel.allowsMultipleSelection = false
        
        if openPanel.runModal() == .OK {
            guard let url = openPanel.url else { return }
            
            do {
                let project = try ProjectManager.shared.loadProject(from: url)
                projectName = project.name
                stockMaterials = project.materials
                cutPieces = project.cutPieces
                layouts = project.layouts
            } catch {
                print("Failed to load project: \(error)")
            }
        }
    }
} 
