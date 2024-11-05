import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: CutListViewModel
    @State private var isAddingMaterial = false
    @State private var isAddingPiece = false
    @State private var showingClearConfirmation = false
    
    var body: some View {
        NavigationSplitView {
            List {
                Section("Stock Materials") {
                    ForEach(viewModel.stockMaterials) { material in
                        MaterialRow(material: material) { updatedMaterial in
                            viewModel.updateMaterial(updatedMaterial)
                        }
                    }
                    Button("Add Material") {
                        isAddingMaterial = true
                    }
                }
                
                Section("Required Pieces") {
                    ForEach(viewModel.cutPieces) { piece in
                        CutPieceRow(piece: piece) { updatedPiece in
                            viewModel.updateCutPiece(updatedPiece)
                        }
                    }
                    Button("Add Piece") {
                        isAddingPiece = true
                    }
                }
            }
        } detail: {
            CutLayoutView(
                stockMaterials: viewModel.stockMaterials, 
                cutPieces: viewModel.cutPieces,
                kerfWidth: viewModel.kerfWidth,
                viewModel: viewModel
            )
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Clear All") {
                    showingClearConfirmation = true
                }
                Button("Optimize") {
                    print("Optimize button pressed")  // Add this line
                    viewModel.optimize()
                }
            }
        }
        .sheet(isPresented: $isAddingMaterial) {
            MaterialEditView { material in
                viewModel.addMaterial(material)
            }
        }
        .sheet(isPresented: $isAddingPiece) {
            CutPieceEditView { piece in
                viewModel.addCutPiece(piece)
            }
        }
        .alert("Clear All", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAll()
            }
        } message: {
            Text("Are you sure you want to remove all materials and pieces? This cannot be undone.")
        }
        .alert("Error", isPresented: .init(
            get: { $viewModel.alertError.wrappedValue != nil },
            set: { if !$0 { viewModel.alertError = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let error = viewModel.alertError {
                Text(error)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CutListViewModel())
} 
