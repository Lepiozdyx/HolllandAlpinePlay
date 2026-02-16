import SwiftUI

struct ContentView: View {
    @State private var storageManager = StorageManager()
    
    var body: some View {
        TabView {
            HomeView(storageManager: storageManager)
                .tabItem {
                    Label("Home", systemImage: Constants.Icons.mountain)
                }
            
            CalendarView(storageManager: storageManager)
                .tabItem {
                    Label("Calendar", systemImage: Constants.Icons.calendar)
                }
            
            StatisticsView(storageManager: storageManager)
                .tabItem {
                    Label("Statistics", systemImage: Constants.Icons.chart)
                }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.cardBackground
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

#Preview {
    ContentView()
}
