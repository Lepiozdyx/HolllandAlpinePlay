import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    let storageManager: StorageManager
    @State private var showAddSheet = false
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
        self._viewModel = State(initialValue: HomeViewModel(storageManager: storageManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                if viewModel.ascents.isEmpty {
                    EmptyStateView(
                        icon: Constants.Icons.mountain,
                        title: "No ascents",
                        subtitle: "Start recording your ascents"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: Constants.Spacing.l) {
                            ForEach(viewModel.ascents) { ascent in
                                NavigationLink {
                                    AscentDetailView(ascent: ascent, storageManager: storageManager)
                                } label: {
                                    AscentCard(ascent: ascent)
                                }
                            }
                        }
                        .padding(Constants.Spacing.l)
                        .padding(.bottom, 80)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        FloatingActionButton {
                            showAddSheet = true
                        }
                        .padding(Constants.Spacing.l)
                    }
                }
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showAddSheet) {
                AddAscentView(storageManager: storageManager)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview("Empty State") {
    HomeView(storageManager: StorageManager())
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
            weather: "☀️",
            temperature: -5,
            windSpeed: 15,
            mood: .euphoria,
            acclimatizationDays: []
        ),
        Ascent(
            name: "Mont Blanc",
            route: "Goûter Route",
            maximumHeight: 4808,
            startDate: Date(),
            temperature: -10,
            mood: .calmness
        )
    ]
    return HomeView(storageManager: storage)
}
