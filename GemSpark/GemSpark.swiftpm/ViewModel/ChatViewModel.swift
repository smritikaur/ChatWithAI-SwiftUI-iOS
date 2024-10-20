import SwiftUI
import GoogleGenerativeAI

class ChatViewModel: ObservableObject {
    @Published var chatHistory: [ChatMessage] = []
    @Published var userPrompt: String = ""
    @Published var response: String = ""
    // initialize the model
    let model = GenerativeModel(name: APIHandler().modelName , apiKey: APIHandler().APIKey)
    
    func generateInteractiveResponse(){
        // Add prompt to chat history
        chatHistory.append(ChatMessage(role: "user", parts: userPrompt, isLoading: false))
        chatHistory.append(ChatMessage(role: "model", parts: "", isLoading: true))
        response = "" //Clear previous response
        Task{
            do {
                let modelContentHistory = try chatHistory.map{history in
                    try ModelContent(role: history.role, parts: [history.parts])}
                //Start new chat session
                let chat = model.startChat(history: modelContentHistory)
                //send user's message
                let streamResponse = chat.sendMessageStream(userPrompt)
                for try await chunk in streamResponse {
                    //update response incrementally
                    if let chunkText = chunk.text {
                        response += chunkText 
                    }
                }
                //Add AI response to chat history
                chatHistory[chatHistory.count - 1] = ChatMessage(role: "model", parts: response, isLoading: false)
                userPrompt = ""
            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
                chatHistory[chatHistory.count - 1] = ChatMessage(role: "model", parts: response, isLoading: false)
            }
        }
    }
}

