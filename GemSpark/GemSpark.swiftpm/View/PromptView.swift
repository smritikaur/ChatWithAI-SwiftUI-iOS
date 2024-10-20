import SwiftUI
struct PromptView: View{
    @EnvironmentObject var chatViewModel: ChatViewModel
    @FocusState var focus: FocusedField?
    @Binding var userPrompt: String
    var body: some View{
        HStack {
            TextField("Message GemSpark", text: $userPrompt, axis: .vertical)
                .focused($focus, equals: .userPrompt)
                .lineLimit(5)
                .font(.title3)
                .padding()
                .background(Color.cyan.opacity(0.2), in: Capsule())
                .autocorrectionDisabled(true)
                .onSubmit{
                    chatViewModel.generateInteractiveResponse()
                    focus = .userPrompt
                }
            Button(action: {
                chatViewModel.generateInteractiveResponse()
                focus = .userPrompt
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.cyan.opacity(0.2))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
        }
    }
    enum FocusedField: Hashable{
        case userPrompt
    }
}

