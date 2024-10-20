import SwiftUI
import GoogleGenerativeAI

struct ChatView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    var body: some View {
        VStack {
            Text("GemSpark")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
                .padding(.top, 40)
            ScrollViewReader { proxy in
                List(chatViewModel.chatHistory){ chat in
                    HStack{
                        if chat.role == "user" {
                            Text("You: \(chat.parts)")
                                .font(.title3)
                                .padding(.leading)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        } else if chat.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                                .scaleEffect(1)
                        } 
                        else {
                            Text("GemSpark: \(chat.parts)")
                                .font(.title3)
                                .padding(.trailing)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .onChange(of: chatViewModel.chatHistory.count){ _ in
                    if let lastMessage = chatViewModel.chatHistory.last {
                        DispatchQueue.main.async{
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            PromptView(userPrompt: $chatViewModel.userPrompt)
        }
        .padding()
    }
}
