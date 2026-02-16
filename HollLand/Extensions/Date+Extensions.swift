import Foundation

extension Date {
    var shortFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let day = Calendar.current.component(.day, from: self)
        let suffix = daySuffix(for: day)
        formatter.dateFormat = "'\(day)\(suffix)' MMM"
        return formatter.string(from: self)
    }
    
    var rangeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        let day = Calendar.current.component(.day, from: self)
        let suffix = daySuffix(for: day)
        formatter.dateFormat = "'\(day)\(suffix)' MMMM yyyy"
        return formatter.string(from: self)
    }
    
    var shortDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let day = Calendar.current.component(.day, from: self)
        let suffix = daySuffix(for: day)
        formatter.dateFormat = "'\(day)\(suffix)' MMM"
        return formatter.string(from: self)
    }
    
    private func daySuffix(for day: Int) -> String {
        switch day {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
    
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func isInRange(start: Date, end: Date) -> Bool {
        let selfDay = self.startOfDay()
        let startDay = start.startOfDay()
        let endDay = end.startOfDay()
        return selfDay >= startDay && selfDay <= endDay
    }
}

extension Date {
    static func dateRange(from start: Date?, to end: Date?) -> String {
        guard let start = start else { return "" }
        if let end = end {
            return "\(start.shortDateRange) — \(end.shortDateRange)"
        } else {
            return start.shortDateRange
        }
    }
}
