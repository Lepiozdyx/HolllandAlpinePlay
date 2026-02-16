import Foundation

@Observable
class AddAscentViewModel {
    let storageManager: StorageManager
    var isEditMode: Bool
    
    var id: UUID
    var name: String
    var route: String
    var maximumHeight: String
    var startDate: Date?
    var endDate: Date?
    var weather: String
    var temperature: String
    var windSpeed: String
    var notes: String
    var selectedMood: Mood
    var acclimatizationDays: [AcclimatizationDay]
    
    init(storageManager: StorageManager, ascent: Ascent? = nil) {
        self.storageManager = storageManager
        self.isEditMode = ascent != nil
        
        if let ascent = ascent {
            self.id = ascent.id
            self.name = ascent.name
            self.route = ascent.route
            self.maximumHeight = ascent.maximumHeight > 0 ? "\(ascent.maximumHeight)" : ""
            self.startDate = ascent.startDate
            self.endDate = ascent.endDate
            self.weather = ascent.weather
            self.temperature = ascent.temperature != 0 ? "\(ascent.temperature)" : ""
            self.windSpeed = ascent.windSpeed > 0 ? "\(ascent.windSpeed)" : ""
            self.notes = ascent.notes
            self.selectedMood = ascent.mood
            self.acclimatizationDays = ascent.acclimatizationDays
        } else {
            self.id = UUID()
            self.name = ""
            self.route = ""
            self.maximumHeight = ""
            self.startDate = nil
            self.endDate = nil
            self.weather = ""
            self.temperature = ""
            self.windSpeed = ""
            self.notes = ""
            self.selectedMood = .calmness
            self.acclimatizationDays = []
        }
    }
    
    func addDay(_ day: AcclimatizationDay) {
        acclimatizationDays.append(day)
        acclimatizationDays.sort { $0.dayNumber < $1.dayNumber }
    }
    
    func updateDay(_ day: AcclimatizationDay) {
        if let index = acclimatizationDays.firstIndex(where: { $0.id == day.id }) {
            acclimatizationDays[index] = day
        }
    }
    
    func deleteDay(_ day: AcclimatizationDay) {
        acclimatizationDays.removeAll { $0.id == day.id }
        for (index, _) in acclimatizationDays.enumerated() {
            acclimatizationDays[index].dayNumber = index + 1
        }
    }
    
    func validate() -> Bool {
        !name.isEmpty && !maximumHeight.isEmpty && validateDateOrder() && validateNoOverlap()
    }
    
    func validateDateOrder() -> Bool {
        guard let start = startDate, let end = endDate else { return true }
        return start.startOfDay() <= end.startOfDay()
    }
    
    func validateNoOverlap() -> Bool {
        guard startDate != nil else { return true }
        return !storageManager.hasOverlappingDates(start: startDate, end: endDate, excludingId: id)
    }
    
    func getDateRangeError() -> String? {
        if let start = startDate, let end = endDate {
            if start.startOfDay() > end.startOfDay() {
                return "End date must be after start date"
            }
        }
        
        if let start = startDate {
            if storageManager.hasOverlappingDates(start: start, end: endDate, excludingId: id) {
                return "These dates overlap with an existing ascent"
            }
        }
        
        return nil
    }
    
    func saveAscent() {
        let ascent = Ascent(
            id: id,
            name: name,
            route: route,
            maximumHeight: Int(maximumHeight) ?? 0,
            startDate: startDate,
            endDate: endDate,
            weather: weather,
            temperature: Int(temperature) ?? 0,
            windSpeed: Int(windSpeed) ?? 0,
            notes: notes,
            mood: selectedMood,
            acclimatizationDays: acclimatizationDays
        )
        
        if isEditMode {
            storageManager.updateAscent(ascent)
        } else {
            storageManager.addAscent(ascent)
        }
    }
}
