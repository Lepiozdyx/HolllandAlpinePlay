import SwiftUI

struct AscentDetailView: View {
    let ascent: Ascent
    let storageManager: StorageManager
    @Environment(\.dismiss) private var dismiss
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Spacing.xl) {
                    HStack(alignment: .top) {
                        Text(ascent.name)
                            .font(Constants.Fonts.largeTitle2)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("\(ascent.maximumHeight) m")
                            .font(Constants.Fonts.largeTitle2)
                            .foregroundStyle(ascent.heightColor)
                    }
                    
                    VStack(spacing: Constants.Spacing.l) {
                        if !ascent.route.isEmpty {
                            HStack(spacing: Constants.Spacing.m) {
                                Image(systemName: Constants.Icons.location)
                                    .foregroundStyle(.hGray)
                                
                                VStack(alignment: .leading, spacing: Constants.Spacing.xs) {
                                    Text("Route")
                                        .font(Constants.Fonts.caption)
                                        .foregroundStyle(.hGray)
                                    
                                    Text(ascent.route)
                                        .font(Constants.Fonts.text)
                                        .foregroundStyle(.white)
                                }
                                
                                Spacer()
                            }
                            .padding(Constants.Spacing.l)
                            .background(.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                        
                        if ascent.startDate != nil {
                            HStack(spacing: Constants.Spacing.m) {
                                Image(systemName: Constants.Icons.calendar)
                                    .foregroundStyle(.hGray)
                                
                                VStack(alignment: .leading, spacing: Constants.Spacing.xs) {
                                    Text("Date")
                                        .font(Constants.Fonts.caption)
                                        .foregroundStyle(.hGray)
                                    
                                    Text(Date.dateRange(from: ascent.startDate, to: ascent.endDate))
                                        .font(Constants.Fonts.text)
                                        .foregroundStyle(.white)
                                }
                                
                                Spacer()
                            }
                            .padding(Constants.Spacing.l)
                            .background(.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                        
                        if !ascent.weather.isEmpty || ascent.temperature != 0 {
                            HStack(spacing: Constants.Spacing.m) {
                                Image(systemName: Constants.Icons.snowflake)
                                    .foregroundStyle(.hGray)
                                
                                VStack(alignment: .leading, spacing: Constants.Spacing.xs) {
                                    Text("Weather")
                                        .font(Constants.Fonts.caption)
                                        .foregroundStyle(.hGray)
                                    
                                    HStack(spacing: Constants.Spacing.m) {
                                        if !ascent.weather.isEmpty {
                                            Text(ascent.weather)
                                                .font(Constants.Fonts.text)
                                        }
                                        
                                        if ascent.temperature != 0 {
                                            Text("\(ascent.temperature > 0 ? "+" : "")\(ascent.temperature)°C")
                                                .font(Constants.Fonts.text)
                                                .foregroundStyle(.white)
                                        }
                                        
                                        if ascent.windSpeed > 0 {
                                            HStack(spacing: Constants.Spacing.s) {
                                                Image(systemName: Constants.Icons.wind)
                                                    .font(.system(size: 12))
                                                Text("\(ascent.windSpeed) m/s")
                                            }
                                            .font(Constants.Fonts.text)
                                            .foregroundStyle(.white)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(Constants.Spacing.l)
                            .background(.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                        Text("Mood")
                            .font(Constants.Fonts.subtitle)
                            .foregroundStyle(.hGray)
                        
                        HStack(spacing: Constants.Spacing.m) {
                            Text(ascent.mood.emoji)
                                .font(.system(size: 24))
                            
                            Text(ascent.mood.title)
                                .font(Constants.Fonts.text2)
                                .foregroundStyle(.white)
                        }
                        .padding(Constants.Spacing.l)
                        .background(.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                    }
                    
                    if !ascent.notes.isEmpty {
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Notes")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            Text(ascent.notes)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(Constants.Spacing.l)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                    }
                    
                    if !ascent.acclimatizationDays.isEmpty {
                        VStack(alignment: .leading, spacing: Constants.Spacing.l) {
                            Text("Acclimatization")
                                .font(Constants.Fonts.title2)
                                .foregroundStyle(.white)
                            
                            VStack(spacing: Constants.Spacing.m) {
                                ForEach(ascent.acclimatizationDays) { day in
                                    DayCard(day: day)
                                }
                            }
                        }
                    }
                }
                .padding(Constants.Spacing.l)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: Constants.Spacing.l) {
                    Button {
                        showEditSheet = true
                    } label: {
                        Image(systemName: Constants.Icons.pencil)
                            .foregroundStyle(.hBlue)
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: Constants.Icons.trash)
                            .foregroundStyle(.hRed)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddAscentView(storageManager: storageManager, ascent: ascent)
        }
        .alert("Delete Ascent", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                storageManager.deleteAscent(id: ascent.id)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this ascent? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        AscentDetailView(
            ascent: Ascent(
                name: "Elbrus",
                route: "Shelter 11 → Pastukhova → Summit",
                maximumHeight: 5642,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                weather: "☀️",
                temperature: -5,
                windSpeed: 15,
                notes: "Amazing summit day with clear views. Challenging final section.",
                mood: .euphoria,
                acclimatizationDays: [
                    AcclimatizationDay(
                        dayNumber: 1,
                        height: 2500,
                        symptoms: [],
                        notes: "First day of acclimatization"
                    ),
                    AcclimatizationDay(
                        dayNumber: 2,
                        height: 3200,
                        symptoms: [.headache, .insomnia],
                        notes: "Mild symptoms appeared"
                    ),
                    AcclimatizationDay(
                        dayNumber: 3,
                        height: 4100,
                        symptoms: [.shortnessOfBreath],
                        notes: "Feeling better"
                    )
                ]
            ),
            storageManager: StorageManager()
        )
    }
}
