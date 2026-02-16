import Foundation

@Observable
class StorageManager {
    var ascents: [Ascent] = []
    
    private let ascentsKey = "saved_ascents"
    
    init() {
        loadAscents()
    }
    
    func loadAscents() {
        guard let data = UserDefaults.standard.data(forKey: ascentsKey),
              let decoded = try? JSONDecoder().decode([Ascent].self, from: data) else {
            ascents = []
            return
        }
        ascents = decoded
    }
    
    func saveAscents() {
        guard let encoded = try? JSONEncoder().encode(ascents) else { return }
        UserDefaults.standard.set(encoded, forKey: ascentsKey)
    }
    
    func addAscent(_ ascent: Ascent) {
        ascents.append(ascent)
        saveAscents()
    }
    
    func updateAscent(_ ascent: Ascent) {
        if let index = ascents.firstIndex(where: { $0.id == ascent.id }) {
            ascents[index] = ascent
            saveAscents()
        }
    }
    
    func deleteAscent(id: UUID) {
        ascents.removeAll { $0.id == id }
        saveAscents()
    }
    
    var topTenAscents: [Ascent] {
        Array(ascents.sorted { $0.maximumHeight > $1.maximumHeight }.prefix(10))
    }
    
    var moodDistribution: [Mood: Int] {
        var distribution: [Mood: Int] = [:]
        for mood in Mood.allCases {
            distribution[mood] = 0
        }
        for ascent in ascents {
            distribution[ascent.mood, default: 0] += 1
        }
        return distribution
    }
    
    var totalAcclimatizationDays: Int {
        ascents.reduce(0) { $0 + $1.acclimatizationDays.count }
    }
    
    var averageHeight: Double {
        guard !ascents.isEmpty else { return 0 }
        let total = ascents.reduce(0) { $0 + $1.maximumHeight }
        return Double(total) / Double(ascents.count)
    }
    
    var maxHeight: Int {
        ascents.map { $0.maximumHeight }.max() ?? 0
    }
    
    func symptomsByAltitude() -> [(symptom: Symptom, avgHeight: Double, count: Int)] {
        var symptomData: [Symptom: (totalHeight: Int, count: Int)] = [:]
        
        for ascent in ascents {
            for day in ascent.acclimatizationDays {
                for symptom in day.symptoms {
                    let current = symptomData[symptom, default: (0, 0)]
                    symptomData[symptom] = (current.totalHeight + day.height, current.count + 1)
                }
            }
        }
        
        return symptomData.map { symptom, data in
            let avgHeight = data.count > 0 ? Double(data.totalHeight) / Double(data.count) : 0
            return (symptom, avgHeight, data.count)
        }.sorted { $0.count > $1.count }
    }
    
    func hasOverlappingDates(start: Date?, end: Date?, excludingId: UUID) -> Bool {
        guard let start = start else { return false }
        
        let startDay = start.startOfDay()
        let endDay = (end ?? start).startOfDay()
        
        for ascent in ascents where ascent.id != excludingId {
            guard let ascentStart = ascent.startDate else { continue }
            
            let ascentStartDay = ascentStart.startOfDay()
            let ascentEndDay = (ascent.endDate ?? ascentStart).startOfDay()
            
            let rangesOverlap = startDay <= ascentEndDay && endDay >= ascentStartDay
            
            if rangesOverlap {
                return true
            }
        }
        
        return false
    }
}
