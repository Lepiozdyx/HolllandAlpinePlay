import SwiftUI

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Constants.Spacing.m) {
                Text(mood.emoji)
                    .font(.system(size: 20))
                
                Text(mood.title)
                    .font(Constants.Fonts.text)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.Components.moodButtonHeight)
            .background(isSelected ? .hYellow : .cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        VStack(spacing: Constants.Spacing.l) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Constants.Spacing.m) {
                MoodButton(mood: .euphoria, isSelected: true) { }
                MoodButton(mood: .fatigue, isSelected: false) { }
                MoodButton(mood: .calmness, isSelected: false) { }
                MoodButton(mood: .anxiety, isSelected: false) { }
            }
        }
        .padding(Constants.Spacing.l)
    }
}
