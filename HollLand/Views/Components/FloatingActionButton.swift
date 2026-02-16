import SwiftUI

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: Constants.Icons.plus)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: Constants.Components.circleButtonSize, height: Constants.Components.circleButtonSize)
                .background(.hBlue)
                .clipShape(Circle())
                .shadow(color: .white.opacity(0.3), radius: 3, x: 1, y: 2)
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingActionButton { }
                    .padding(Constants.Spacing.l)
            }
        }
    }
}
