import SwiftUI
import UniformTypeIdentifiers

class PDFGenerator {
    static func generatePDF(from layouts: [CutLayout]) -> Data? {
        // Create PDF data consumer
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp.pdf")
        
        // Calculate size
        let size = CGSize(
            width: max(842, layouts.reduce(0) { maxWidth, layout in
                max(maxWidth, layout.material.width * 4 + 100)
            }),
            height: max(595, layouts.reduce(0) { totalHeight, layout in
                totalHeight + (layout.material.length * 4 + 200)
            })
        )
        
        // Create printable content
        let contentView = PrintableView(layouts: layouts)
            .frame(width: size.width, height: size.height)
        
        // Create hosting view
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = CGRect(origin: .zero, size: size)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.white.cgColor
        
        // Create PDF context
        guard let context = CGContext(tempURL as CFURL, mediaBox: nil, nil) else {
            return nil
        }
        
        // Begin PDF page
        context.beginPDFPage(nil)
        
        // Create bitmap representation
        let imageRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
        hostingView.cacheDisplay(in: hostingView.bounds, to: imageRep)
        
        // Draw the image
        if let cgImage = imageRep.cgImage {
            context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        }
        
        // End PDF page and context
        context.endPDFPage()
        context.closePDF()
        
        // Get PDF data
        let pdfData = try? Data(contentsOf: tempURL)
        try? FileManager.default.removeItem(at: tempURL)
        
        return pdfData
    }
}