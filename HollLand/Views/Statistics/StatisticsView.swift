import SwiftUI
import Charts

struct StatisticsView: View {
    @State private var viewModel: StatisticsViewModel
    let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
        self._viewModel = State(initialValue: StatisticsViewModel(storageManager: storageManager))
    }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                if storageManager.ascents.isEmpty {
                    EmptyStateView(
                        icon: Constants.Icons.chart,
                        title: "No statistics",
                        subtitle: "Start recording your ascents"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: Constants.Spacing.xl) {
                            VStack(alignment: .leading, spacing: Constants.Spacing.l) {
                                HStack {
                                    Image(systemName: Constants.Icons.medal)
                                        .foregroundStyle(.hYellow)
                                    
                                    Text("TOP-10 Ascents")
                                        .font(Constants.Fonts.title2)
                                        .foregroundStyle(.white)
                                }
                                
                                LazyVGrid(columns: columns, spacing: Constants.Spacing.m) {
                                    ForEach(Array(viewModel.topTenAscents.enumerated()), id: \.element.id) { index, ascent in
                                        VStack(alignment: .leading, spacing: Constants.Spacing.s) {
                                            if index == 0 {
                                                HStack {
                                                    Image(systemName: Constants.Icons.medal)
                                                        .foregroundStyle(.hYellow)
                                                        .font(.system(size: 12))
                                                    
                                                    Text(ascent.name)
                                                        .font(Constants.Fonts.text2)
                                                        .foregroundStyle(.white)
                                                        .lineLimit(1)
                                                }
                                            } else {
                                                Text(ascent.name)
                                                    .font(Constants.Fonts.text2)
                                                    .foregroundStyle(.white)
                                                    .lineLimit(1)
                                            }
                                            
                                            Text("\(ascent.maximumHeight) m")
                                                .font(Constants.Fonts.title2)
                                                .foregroundStyle(Constants.Colors.textGradient)
                                            
                                            if !ascent.route.isEmpty {
                                                Text(ascent.route)
                                                    .font(Constants.Fonts.caption)
                                                    .foregroundStyle(.hGray)
                                                    .lineLimit(1)
                                            }
                                        }
                                        .padding(Constants.Spacing.m)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.cardBackground)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: Constants.CornerRadius.main)
                                        )
                                    }
                                }
                            }
                            .padding(Constants.Spacing.m)
                            .background(.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                            
                            if !viewModel.symptomChartData.isEmpty {
                                VStack(alignment: .leading, spacing: Constants.Spacing.l) {
                                    VStack(alignment: .leading, spacing: Constants.Spacing.s) {
                                        Text("Altitude Symptoms")
                                            .font(Constants.Fonts.title2)
                                            .foregroundStyle(.white)
                                        
                                        Text("Frequency of Symptoms and Average Altitude of Manifestation")
                                            .font(Constants.Fonts.caption)
                                            .foregroundStyle(.hGray)
                                    }
                                    
                                    Chart {
                                        ForEach(viewModel.symptomChartData, id: \.height) { data in
                                            LineMark(
                                                x: .value("Height", data.height),
                                                y: .value("Frequency", data.frequency)
                                            )
                                            .foregroundStyle(.hRed)
                                            .lineStyle(StrokeStyle(lineWidth: 2))
                                            
                                            PointMark(
                                                x: .value("Height", data.height),
                                                y: .value("Frequency", data.frequency)
                                            )
                                            .foregroundStyle(.hRed)
                                            .symbolSize(50)
                                        }
                                    }
                                    .frame(height: 200)
                                    .chartXAxis {
                                        AxisMarks(position: .bottom) { _ in
                                            AxisGridLine()
                                            AxisValueLabel()
                                                .foregroundStyle(.hGray)
                                        }
                                    }
                                    .chartYAxis {
                                        AxisMarks(position: .leading) { _ in
                                            AxisGridLine()
                                            AxisValueLabel()
                                                .foregroundStyle(.hGray)
                                        }
                                    }
                                }
                                .padding(Constants.Spacing.l)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                            }
                            
                            if !viewModel.moodDistribution.isEmpty {
                                VStack(alignment: .leading, spacing: Constants.Spacing.l) {
                                    Text("Mood Distribution")
                                        .font(Constants.Fonts.title2)
                                        .foregroundStyle(.white)
                                    
                                    Chart(viewModel.moodDistribution, id: \.mood) { item in
                                        SectorMark(
                                            angle: .value("Count", item.count),
                                            innerRadius: .ratio(0.5),
                                            angularInset: 2
                                        )
                                        .foregroundStyle(moodColor(item.mood))
                                    }
                                    .frame(height: 200)
                                    
                                    VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                                        ForEach(viewModel.moodDistribution, id: \.mood) { item in
                                            HStack(spacing: Constants.Spacing.m) {
                                                Circle()
                                                    .fill(moodColor(item.mood))
                                                    .frame(width: 12, height: 12)
                                                
                                                Text(item.mood.emoji)
                                                    .font(.system(size: 16))
                                                
                                                Text(item.mood.title)
                                                    .font(Constants.Fonts.text)
                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                                
                                                Text("\(Int(item.percentage))%")
                                                    .font(Constants.Fonts.text2)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }
                                .padding(Constants.Spacing.l)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                            }
                            
                            VStack(alignment: .leading, spacing: Constants.Spacing.l) {
                                Text("Overall Statistics")
                                    .font(Constants.Fonts.title2)
                                    .foregroundStyle(.white)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Constants.Spacing.m) {
                                    StatCard(title: "Total Ascents", value: "\(viewModel.totalAscents)")
                                    StatCard(title: "Max Height", value: "\(viewModel.maxHeight) m")
                                    StatCard(title: "Acclimatization Days", value: "\(viewModel.totalAcclimatizationDays)")
                                    StatCard(title: "Average Height", value: String(format: "%.0f m", viewModel.avgHeight))
                                }
                            }
                        }
                        .padding(Constants.Spacing.l)
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
    
    private func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .euphoria: return .hYellow
        case .fatigue: return .hGray
        case .calmness: return .hBlue
        case .anxiety: return Color.orange
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.s) {
            Text(title)
                .font(Constants.Fonts.subtitle)
                .foregroundStyle(.hGray)
            
            Text(value)
                .font(Constants.Fonts.title2)
                .foregroundStyle(.white)
        }
        .padding(Constants.Spacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
    }
}

#Preview("With Data") {
    let storage = StorageManager()
    storage.ascents = [
        Ascent(
            name: "Elbrus",
            route: "Shelter 11 → Pastukhova → Summit",
            maximumHeight: 5642,
            startDate: Date(),
            mood: .euphoria,
            acclimatizationDays: [
                AcclimatizationDay(dayNumber: 1, height: 2500, symptoms: [.headache]),
                AcclimatizationDay(dayNumber: 2, height: 3200, symptoms: [.headache, .insomnia]),
                AcclimatizationDay(dayNumber: 3, height: 4100, symptoms: [.shortnessOfBreath])
            ]
        ),
        Ascent(
            name: "Mont Blanc",
            maximumHeight: 4808,
            mood: .calmness,
            acclimatizationDays: [
                AcclimatizationDay(dayNumber: 1, height: 3000, symptoms: [.headache])
            ]
        ),
        Ascent(
            name: "Kilimanjaro",
            maximumHeight: 5895,
            mood: .euphoria
        ),
        Ascent(
            name: "Aconcagua",
            maximumHeight: 6962,
            mood: .fatigue
        ),
        Ascent(
            name: "Denali",
            maximumHeight: 6190,
            mood: .anxiety
        )
    ]
    return StatisticsView(storageManager: storage)
}
