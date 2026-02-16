import SwiftUI

struct Ascent: Identifiable, Codable {
    let id: UUID
    var name: String
    var route: String
    var maximumHeight: Int
    var startDate: Date?
    var endDate: Date?
    var weather: String
    var temperature: Int
    var windSpeed: Int
    var notes: String
    var mood: Mood
    var acclimatizationDays: [AcclimatizationDay]
    
    init(
        id: UUID = UUID(),
        name: String = "",
        route: String = "",
        maximumHeight: Int = 0,
        startDate: Date? = nil,
        endDate: Date? = nil,
        weather: String = "",
        temperature: Int = 0,
        windSpeed: Int = 0,
        notes: String = "",
        mood: Mood = .calmness,
        acclimatizationDays: [AcclimatizationDay] = []
    ) {
        self.id = id
        self.name = name
        self.route = route
        self.maximumHeight = maximumHeight
        self.startDate = startDate
        self.endDate = endDate
        self.weather = weather
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.notes = notes
        self.mood = mood
        self.acclimatizationDays = acclimatizationDays
    }
    
    var heightColor: Color {
        switch maximumHeight {
        case ..<3000: return .hGreen
        case 3000..<4500: return .hYellow
        default: return .hRed
        }
    }
}
