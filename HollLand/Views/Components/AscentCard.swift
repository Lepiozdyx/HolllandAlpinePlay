import SwiftUI

struct AscentCard: View {
    let ascent: Ascent
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
            HStack(alignment: .top) {
                Text(ascent.name)
                    .font(Constants.Fonts.title2)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(ascent.maximumHeight) m")
                    .font(Constants.Fonts.title2)
                    .foregroundStyle(ascent.heightColor)
            }
            
            if !ascent.route.isEmpty {
                Text(ascent.route)
                    .font(Constants.Fonts.subtitle)
                    .foregroundStyle(.hGray)
                    .lineLimit(1)
            }
            
            HStack {
                if let startDate = ascent.startDate {
                    Text(Date.dateRange(from: startDate, to: ascent.endDate))
                        .font(Constants.Fonts.subtitle)
                        .foregroundStyle(.hGray)
                }
                
                Spacer()
                
                if ascent.temperature != 0 {
                    Text("\(ascent.temperature > 0 ? "+" : "")\(ascent.temperature)°C")
                        .font(Constants.Fonts.subtitle)
                        .foregroundStyle(.hGray)
                }
            }
        }
        .padding(Constants.Spacing.l)
        .background(.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        VStack(spacing: Constants.Spacing.l) {
            AscentCard(
                ascent: Ascent(
                    name: "Elbrus",
                    route: "Shelter 11 → Pastukhova → Summit",
                    maximumHeight: 5642,
                    startDate: Date(),
                    endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                    weather: "☀️",
                    temperature: -5,
                    windSpeed: 15,
                    notes: "",
                    mood: .euphoria
                )
            )
            
            AscentCard(
                ascent: Ascent(
                    name: "Mont Blanc",
                    route: "Goûter Route",
                    maximumHeight: 4808,
                    startDate: Date(),
                    temperature: -10,
                    mood: .calmness
                )
            )
        }
        .padding(Constants.Spacing.l)
    }
}
