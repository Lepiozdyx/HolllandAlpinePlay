import SwiftUI

enum Mood: String, Codable, CaseIterable {
    case euphoria
    case fatigue
    case calmness
    case anxiety
    
    var emoji: String {
        switch self {
        case .euphoria: return "🤩"
        case .fatigue: return "😴"
        case .calmness: return "😌"
        case .anxiety: return "😨"
        }
    }
    
    var title: String {
        switch self {
        case .euphoria: return "Euphoria"
        case .fatigue: return "Fatigue"
        case .calmness: return "Calmness"
        case .anxiety: return "Anxiety"
        }
    }
}
