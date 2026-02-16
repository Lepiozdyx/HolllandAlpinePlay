import SwiftUI

@Observable
class CalendarViewModel {
    let storageManager: StorageManager
    var currentMonth: Date = Date()
    var selectedDate: Date?
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    func goToToday() {
        currentMonth = Date()
    }
    
    func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth)!
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmptyDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: leadingEmptyDays)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    func ascentForDate(_ date: Date) -> Ascent? {
        let matchingAscents = storageManager.ascents.filter { ascent in
            guard let startDate = ascent.startDate else { return false }
            let start = startDate.startOfDay()
            let end = (ascent.endDate ?? startDate).startOfDay()
            let currentDate = date.startOfDay()
            return currentDate >= start && currentDate <= end
        }
        
        return matchingAscents.sorted { $0.maximumHeight > $1.maximumHeight }.first
    }
    
    func colorForDate(_ date: Date) -> Color? {
        guard let ascent = ascentForDate(date) else { return nil }
        return ascent.heightColor
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
}
