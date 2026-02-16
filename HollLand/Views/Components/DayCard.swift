import SwiftUI

struct DayCard: View {
    let day: AcclimatizationDay
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
            HStack {
                Text("Day \(day.dayNumber)")
                    .font(Constants.Fonts.text2)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(day.height) m")
                    .font(Constants.Fonts.text2)
                    .foregroundStyle(.hGreen)
            }
            
            if !day.symptoms.isEmpty {
                VStack(alignment: .leading, spacing: Constants.Spacing.s) {
                    Text("Symptoms:")
                        .font(Constants.Fonts.subtitle)
                        .foregroundStyle(.hGray)
                    
                    FlowLayout(spacing: Constants.Spacing.s) {
                        ForEach(day.symptoms, id: \.self) { symptom in
                            Text(symptom.rawValue)
                                .font(Constants.Fonts.caption)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.m)
                                .padding(.vertical, Constants.Spacing.s)
                                .background(.hRed.opacity(0.8))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            if !day.notes.isEmpty {
                VStack(alignment: .leading, spacing: Constants.Spacing.s) {
                    Text("Notes:")
                        .font(Constants.Fonts.subtitle)
                        .foregroundStyle(.hGray)
                    
                    Text(day.notes)
                        .font(Constants.Fonts.subtitle)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(Constants.Spacing.l)
        .background(.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        VStack(spacing: Constants.Spacing.l) {
            DayCard(
                day: AcclimatizationDay(
                    dayNumber: 1,
                    height: 2500,
                    symptoms: [.headache, .insomnia],
                    notes: "Normal sleep, reduced appetite"
                )
            )
            
            DayCard(
                day: AcclimatizationDay(
                    dayNumber: 2,
                    height: 3200
                )
            )
            
            DayCard(
                day: AcclimatizationDay(
                    dayNumber: 3,
                    height: 4100,
                    symptoms: [.headache, .nausea, .shortnessOfBreath, .weakness],
                    notes: "Feeling better after rest"
                )
            )
        }
        .padding(Constants.Spacing.l)
    }
}
