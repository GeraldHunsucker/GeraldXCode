import SwiftUI

struct CutLayoutView: View {
    let stockMaterials: [Material]
    let cutPieces: [CutPiece]
    let kerfWidth: Double
    @ObservedObject var viewModel: CutListViewModel
    @State private var zoomLevel: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading, spacing: 4) {
                    if stockMaterials.isEmpty {
                        ContentUnavailableView {
                            Label("No Layout Available", systemImage: "square.dashed")
                        } description: {
                            Text("Add stock materials to get started")
                        }
                    } else if viewModel.layouts.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(stockMaterials) { material in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(material.name)
                                        .font(.headline)
                                    
                                    Rectangle()
                                        .stroke(.secondary, lineWidth: 2)
                                        .frame(
                                            width: material.width * 4,
                                            height: material.length * 4
                                        )
                                        .background(Color.white)
                                }
                                .padding()
                                .background(Color.white)
                                .scaleEffect(zoomLevel)
                            }
                        }
                        .padding()
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                if totalCost > 0 {
                                    Text("Total Cost: \(totalCost, format: .currency(code: "USD"))")
                                        .font(.headline)
                                }
                                Spacer()
                                Text("Sheets Required: \(viewModel.layouts.count)")
                                    .font(.headline)
                            }
                            
                            // Container for all sheets
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(viewModel.layouts.enumerated()), id: \.element.id) { index, layout in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Sheet \(index + 1)")
                                            .font(.title2)
                                        OptimizedSheetView(layout: layout)
                                    }
                                    .padding(.bottom, 40)  // Fixed spacing between sheets
                                }
                            }
                            .scaleEffect(zoomLevel)  // Apply zoom to entire container
                        }
                        .id("printableLayoutContent")
                    }
                }
            }
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel, .keyDown]) { event in
                if event.modifierFlags.contains(.command) && event.type == .scrollWheel {
                    let delta = event.scrollingDeltaY * 0.01
                    zoomLevel = min(max(zoomLevel * (1 + delta), 0.2), 5.0)
                    return nil
                } else if event.type == .keyDown {
                    switch event.keyCode {
                    case 29:  // Command + 0
                        if event.modifierFlags.contains(.command) {
                            zoomLevel = 1.0
                            return nil
                        }
                    case 126:  // Up arrow
                        zoomLevel = min(zoomLevel + 0.1, 5.0)
                        return nil
                    case 125:  // Down arrow
                        zoomLevel = max(zoomLevel - 0.1, 0.2)
                        return nil
                    default:
                        break
                    }
                }
                return event
            }
        }
    }
    
    var totalCost: Double {
        viewModel.layouts.reduce(0) { sum, layout in
            sum + layout.material.cost
        }
    }
}
