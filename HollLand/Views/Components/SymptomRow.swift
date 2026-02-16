import SwiftUI

struct SymptomRow: View {
    let symptom: Symptom
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(symptom.rawValue)
                    .font(Constants.Fonts.text)
                    .foregroundStyle(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: Constants.Icons.checkmark)
                        .foregroundStyle(.hBlue)
                }
            }
            .padding(.horizontal, Constants.Spacing.l)
            .frame(height: Constants.Components.symptomRowHeight)
            .background(.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.CornerRadius.main)
                    .stroke(isSelected ? Color.hBlue : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        VStack(spacing: Constants.Spacing.s) {
            SymptomRow(symptom: .headache, isSelected: true) { }
            SymptomRow(symptom: .nausea, isSelected: false) { }
            SymptomRow(symptom: .insomnia, isSelected: true) { }
            SymptomRow(symptom: .weakness, isSelected: false) { }
        }
        .padding(Constants.Spacing.l)
    }
}
