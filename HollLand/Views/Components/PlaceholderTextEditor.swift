import SwiftUI

struct PlaceholderTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let height: CGFloat
    var isFocused: FocusState<Bool>.Binding?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(Constants.Fonts.text)
                    .foregroundStyle(.hGray.opacity(0.5))
                    .padding(.horizontal, Constants.Spacing.m + 4)
                    .padding(.vertical, Constants.Spacing.m + 8)
            }
            
            Group {
                if let isFocused = isFocused {
                    TextEditor(text: $text)
                        .font(Constants.Fonts.text)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .padding(Constants.Spacing.m)
                        .focused(isFocused)
                } else {
                    TextEditor(text: $text)
                        .font(Constants.Fonts.text)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .padding(Constants.Spacing.m)
                }
            }
        }
        .frame(height: height)
        .background(.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        VStack(spacing: Constants.Spacing.l) {
            PlaceholderTextEditor(
                text: .constant(""),
                placeholder: "Normal sleep, reduced appetite",
                height: Constants.Components.textEditor
            )
            
            PlaceholderTextEditor(
                text: .constant("Good acclimatization, no symptoms"),
                placeholder: "Normal sleep, reduced appetite",
                height: Constants.Components.textEditor
            )
        }
        .padding(Constants.Spacing.l)
    }
}
