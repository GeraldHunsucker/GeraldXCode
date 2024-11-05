import SwiftUI

struct HelpWindow: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Cut List Help")
                        .font(.largeTitle)
                        .padding(.bottom)
                    
                    Section("Getting Started") {
                        Text("1. Add stock materials using the 'Add Material' button")
                        Text("2. Add required pieces using the 'Add Piece' button")
                        Text("3. Click 'Optimize' to generate the cutting layout")
                    }
                    
                    Section("Materials") {
                        Text("• Choose from common materials or create custom ones")
                        Text("• Set dimensions, quantity, and cost")
                        Text("• Specify grain direction if needed")
                        Text("• Set kerf thickness for the saw blade")
                    }
                    
                    Section("Cut Pieces") {
                        Text("• Enter dimensions and quantity needed")
                        Text("• Label pieces for easy identification")
                        Text("• Specify grain direction requirements")
                    }
                    
                    Section("Optimization") {
                        Text("• Click 'Optimize' or use Command+R")
                        Text("• View layouts with piece placement")
                        Text("• See waste percentage and total cost")
                    }
                    
                    Section("Zoom Controls") {
                        Text("• Command + Scroll to zoom in/out")
                        Text("• Up/Down arrows to adjust zoom")
                        Text("• Command + 0 to reset zoom")
                    }
                    
                    Section("Printing and Export") {
                        Text("• Command+P to print")
                        Text("• Command+Shift+E to export PDF")
                        Text("• Command+Shift+P for page setup")
                    }
                    
                    Section("Project Management") {
                        Text("• Command+N for new project")
                        Text("• Command+S to save project")
                        Text("• Command+O to open project")
                    }
                }
                .textSelection(.enabled)
            }
            .padding()
        }
        .frame(width: 600, height: 500)
    }
}

private struct Section<Content: View>: View {
    let title: String
    let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content
        }
    }
} 