import SwiftUI

struct MainMenu: Commands {
    @ObservedObject var viewModel: CutListViewModel
    
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Page Setup...") {
                showPageSetup()
            }
            .keyboardShortcut("p", modifiers: [.command, .shift])
        }
    }
    
    private func showPageSetup() {
        let printInfo = NSPrintInfo.shared
        let pageLayout = NSPageLayout()
        pageLayout.beginSheet(with: printInfo, modalFor: NSApp.mainWindow!, delegate: nil, didEnd: nil, contextInfo: nil)
    }
} 