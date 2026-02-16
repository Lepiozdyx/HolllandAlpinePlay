import SwiftUI

struct CalendarView: View {
    @State private var viewModel: CalendarViewModel
    let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
        self._viewModel = State(initialValue: CalendarViewModel(storageManager: storageManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                if storageManager.ascents.isEmpty {
                    EmptyStateView(
                        icon: Constants.Icons.calendar,
                        title: "No ascents",
                        subtitle: "Start recording your ascents"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: Constants.Spacing.xl) {
                            VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                                Text("Height colour indication:")
                                    .font(Constants.Fonts.subtitle)
                                    .foregroundStyle(.hGray)
                                
                                HStack(spacing: Constants.Spacing.xl) {
                                    HStack(spacing: Constants.Spacing.s) {
                                        Circle()
                                            .fill(.hGreen)
                                            .frame(width: 8, height: 8)
                                        
                                        Text("up to\n3000 m")
                                            .font(Constants.Fonts.caption)
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    HStack(spacing: Constants.Spacing.s) {
                                        Circle()
                                            .fill(.hYellow)
                                            .frame(width: 8, height: 8)
                                        
                                        Text("3000-4500 m")
                                            .font(Constants.Fonts.caption)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    HStack(spacing: Constants.Spacing.s) {
                                        Circle()
                                            .fill(.hRed)
                                            .frame(width: 8, height: 8)
                                        
                                        Text("4500+ m")
                                            .font(Constants.Fonts.caption)
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .padding(Constants.Spacing.l)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                            
                            VStack(spacing: Constants.Spacing.l) {
                                HStack {
                                    Button {
                                        viewModel.previousMonth()
                                    } label: {
                                        Image(systemName: Constants.Icons.chevronLeft)
                                            .foregroundStyle(.white)
                                            .frame(width: 32, height: 32)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(viewModel.monthYearString)
                                        .font(Constants.Fonts.title2)
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                    
                                    Button {
                                        viewModel.nextMonth()
                                    } label: {
                                        Image(systemName: Constants.Icons.chevronRight)
                                            .foregroundStyle(.white)
                                            .frame(width: 32, height: 32)
                                    }
                                }
                                
                                Button {
                                    viewModel.goToToday()
                                } label: {
                                    Text("Today")
                                        .font(Constants.Fonts.text)
                                        .foregroundStyle(.hBlue)
                                }
                                
                                VStack(spacing: Constants.Spacing.m) {
                                    HStack {
                                        ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                                            Text(day)
                                                .font(Constants.Fonts.caption)
                                                .foregroundStyle(.hGray)
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                    
                                    let days = viewModel.daysInMonth()
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Constants.Spacing.m) {
                                        ForEach(0..<days.count, id: \.self) { index in
                                            if let date = days[index] {
                                                CalendarDayCell(
                                                    date: date,
                                                    color: viewModel.colorForDate(date),
                                                    ascent: viewModel.ascentForDate(date),
                                                    storageManager: storageManager
                                                )
                                            } else {
                                                Color.clear
                                                    .frame(height: 40)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(Constants.Spacing.l)
                            .background(.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                        .padding(Constants.Spacing.l)
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

struct CalendarDayCell: View {
    let date: Date
    let color: Color?
    let ascent: Ascent?
    let storageManager: StorageManager
    
    var body: some View {
        if let ascent = ascent {
            NavigationLink {
                AscentDetailView(ascent: ascent, storageManager: storageManager)
            } label: {
                dayContent
            }
        } else {
            dayContent
        }
    }
    
    private var dayContent: some View {
        VStack(spacing: Constants.Spacing.xs) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(Constants.Fonts.text)
                .foregroundStyle(ascent != nil ? .white : .hGray)
            
            if let color = color {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
            } else {
                Color.clear
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 40)
    }
}

#Preview("Empty Calendar") {
    CalendarView(storageManager: StorageManager())
}

#Preview("With Ascents") {
    let storage = StorageManager()
    storage.ascents = [
        Ascent(
            name: "Elbrus",
            route: "Shelter 11 → Pastukhova → Summit",
            maximumHeight: 5642,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            mood: .euphoria
        ),
        Ascent(
            name: "Mont Blanc",
            route: "Goûter Route",
            maximumHeight: 4808,
            startDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()),
            mood: .calmness
        )
    ]
    return CalendarView(storageManager: storage)
}
