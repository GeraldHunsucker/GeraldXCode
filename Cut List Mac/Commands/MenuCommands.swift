import SwiftUI
import AppKit

struct MenuCommands: Commands {
    @ObservedObject var viewModel: CutListViewModel
    @State private var isShowingPrintDialog = false
    private static var helpWindowController: NSWindowController?
    
    var body: some Commands {
        // File Menu
        CommandGroup(replacing: .newItem) {
            Button("New Project") {
                viewModel.clearAll()
            }
            .keyboardShortcut("n", modifiers: .command)
            
            Button("Open...") {
                viewModel.loadProject()
            }
            .keyboardShortcut("o", modifiers: .command)
            
            Button("Save...") {
                viewModel.saveProject()
            }
            .keyboardShortcut("s", modifiers: .command)
        }
        
        // Edit Menu
        CommandGroup(replacing: .pasteboard) {
            Button("Optimize Layout") {
                DispatchQueue.main.async {
                    if !viewModel.stockMaterials.isEmpty && !viewModel.cutPieces.isEmpty {
                        viewModel.optimize()
                    }
                }
            }
            .keyboardShortcut("r", modifiers: .command)
            .disabled(viewModel.stockMaterials.isEmpty || viewModel.cutPieces.isEmpty)
            
            Divider()
            
            Button("Add Material...") {
                // TODO: Add material
            }
            .keyboardShortcut("m", modifiers: [.command, .shift])
            
            Button("Add Cut Piece...") {
                // TODO: Add cut piece
            }
            .keyboardShortcut("n", modifiers: [.command, .shift])
        }
        
        // File Menu Print Items
        CommandGroup(after: .newItem) {
            Divider()
            
            Button("Page Setup...") {
                DispatchQueue.main.async {
                    if let window = NSApp.mainWindow {
                        let printInfo = NSPrintInfo.shared
                        let pageLayout = NSPageLayout()
                        pageLayout.beginSheet(with: printInfo, modalFor: window, delegate: nil, didEnd: nil, contextInfo: nil)
                    }
                }
            }
            .keyboardShortcut("p", modifiers: [.command, .shift])
            
            Button("Print...") {
                DispatchQueue.main.async {
                    if !viewModel.layouts.isEmpty {
                        viewModel.printLayout()
                    }
                }
            }
            .keyboardShortcut("p", modifiers: .command)
            .disabled(viewModel.layouts.isEmpty)
            
            Button("Export PDF...") {
                DispatchQueue.main.async {
                    if !viewModel.layouts.isEmpty {
                        viewModel.exportPDF()
                    }
                }
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
            .disabled(viewModel.layouts.isEmpty)
        }
        
        // Help Menu
        CommandGroup(replacing: .help) {
            Button("Cut List Help") {
                // Close existing help window if it exists
                Self.helpWindowController?.close()
                
                // Create new help window
                let helpWindow = NSWindow(
                    contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
                    styleMask: [.titled, .closable, .miniaturizable],
                    backing: .buffered,
                    defer: false
                )
                
                helpWindow.title = "Cut List Help"
                helpWindow.contentView = NSHostingView(rootView: HelpView())
                helpWindow.center()
                
                // Create and store window controller
                let windowController = NSWindowController(window: helpWindow)
                Self.helpWindowController = windowController
                
                windowController.showWindow(nil)
            }
            .keyboardShortcut("?", modifiers: .command)
        }
    }
} 