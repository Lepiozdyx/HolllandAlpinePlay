import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: Constants.Spacing.l) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(.hGray.opacity(0.5))
            
            VStack(spacing: Constants.Spacing.s) {
                Text(title)
                    .font(Constants.Fonts.title2)
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(Constants.Fonts.subtitle)
                    .foregroundStyle(.hGray)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        EmptyStateView(
            icon: Constants.Icons.mountain,
            title: "No ascents",
            subtitle: "Start recording your ascents"
        )
    }
}
