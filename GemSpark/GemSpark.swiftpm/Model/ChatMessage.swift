import SwiftUI
struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String
    let parts: String
    var isLoading: Bool
}
