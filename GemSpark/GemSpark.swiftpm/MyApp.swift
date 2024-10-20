import SwiftUI

@main
struct MyApp: App {
    @StateObject var chatViewModel = ChatViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chatViewModel)
        }
    }
}
