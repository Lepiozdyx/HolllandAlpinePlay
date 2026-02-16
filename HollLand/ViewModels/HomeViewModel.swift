import Foundation

@Observable
class HomeViewModel {
    let storageManager: StorageManager
    
    var ascents: [Ascent] {
        storageManager.ascents.sorted { a, b in
            (a.startDate ?? .distantPast) > (b.startDate ?? .distantPast)
        }
    }
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func deleteAscent(id: UUID) {
        storageManager.deleteAscent(id: id)
    }
}
