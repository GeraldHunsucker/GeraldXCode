import SwiftUI

struct HelpCommands: Commands {
    @State private var showingHelp = false
    
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Button("Cut List Help") {
                if let mainWindow = NSApp.mainWindow {
                    let helpWindow = NSWindow(
                        contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
                        styleMask: [.titled, .closable, .miniaturizable],
                        backing: .buffered,
                        defer: false
                    )
                    helpWindow.title = "Cut List Help"
                    helpWindow.contentView = NSHostingView(rootView: HelpView())
                    helpWindow.center()
                    
                    mainWindow.addChildWindow(helpWindow, ordered: .above)
                    helpWindow.makeKeyAndOrderFront(nil)
                }
            }
            .keyboardShortcut("?", modifiers: .command)
        }
    }
} 