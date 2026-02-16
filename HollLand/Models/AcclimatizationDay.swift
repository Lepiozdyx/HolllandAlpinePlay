import Foundation

struct AcclimatizationDay: Identifiable, Codable {
    let id: UUID
    var dayNumber: Int
    var height: Int
    var symptoms: [Symptom]
    var notes: String
    
    init(id: UUID = UUID(), dayNumber: Int, height: Int, symptoms: [Symptom] = [], notes: String = "") {
        self.id = id
        self.dayNumber = dayNumber
        self.height = height
        self.symptoms = symptoms
        self.notes = notes
    }
}
