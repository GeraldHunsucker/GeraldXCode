import SwiftUI

@main
struct CutListApp: App {
    @StateObject private var viewModel = CutListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .commands {
            MenuCommands(viewModel: viewModel)
            SidebarCommands()
        }
    }
} 