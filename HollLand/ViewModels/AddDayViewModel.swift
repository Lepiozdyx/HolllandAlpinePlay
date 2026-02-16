import Foundation

@Observable
class AddDayViewModel {
    var dayNumber: Int
    var height: String
    var selectedSymptoms: Set<Symptom>
    var notes: String
    var existingDay: AcclimatizationDay?
    
    init(dayNumber: Int, existingDay: AcclimatizationDay? = nil) {
        self.dayNumber = dayNumber
        self.existingDay = existingDay
        
        if let day = existingDay {
            self.height = "\(day.height)"
            self.selectedSymptoms = Set(day.symptoms)
            self.notes = day.notes
        } else {
            self.height = ""
            self.selectedSymptoms = []
            self.notes = ""
        }
    }
    
    func toggleSymptom(_ symptom: Symptom) {
        if selectedSymptoms.contains(symptom) {
            selectedSymptoms.remove(symptom)
        } else {
            selectedSymptoms.insert(symptom)
        }
    }
    
    func createDay() -> AcclimatizationDay? {
        guard let heightValue = Int(height), heightValue > 0 else { return nil }
        
        return AcclimatizationDay(
            id: existingDay?.id ?? UUID(),
            dayNumber: dayNumber,
            height: heightValue,
            symptoms: Array(selectedSymptoms).sorted { $0.rawValue < $1.rawValue },
            notes: notes
        )
    }
}
