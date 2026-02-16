import Foundation

@Observable
class StatisticsViewModel {
    let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    var topTenAscents: [Ascent] {
        storageManager.topTenAscents
    }
    
    var moodDistribution: [(mood: Mood, count: Int, percentage: Double)] {
        let distribution = storageManager.moodDistribution
        let total = storageManager.ascents.count
        guard total > 0 else { return [] }
        
        return Mood.allCases.compactMap { mood in
            let count = distribution[mood] ?? 0
            let percentage = Double(count) / Double(total) * 100
            return (mood, count, percentage)
        }.filter { $0.count > 0 }
    }
    
    var symptomChartData: [(height: Int, frequency: Int)] {
        let symptoms = storageManager.symptomsByAltitude()
        
        var heightRanges: [Int: Int] = [:]
        for symptom in symptoms {
            let roundedHeight = Int(symptom.avgHeight / 500) * 500
            heightRanges[roundedHeight, default: 0] += symptom.count
        }
        
        return heightRanges.map { ($0.key, $0.value) }.sorted { $0.height < $1.height }
    }
    
    var totalAscents: Int {
        storageManager.ascents.count
    }
    
    var maxHeight: Int {
        storageManager.maxHeight
    }
    
    var avgHeight: Double {
        storageManager.averageHeight
    }
    
    var totalAcclimatizationDays: Int {
        storageManager.totalAcclimatizationDays
    }
}
