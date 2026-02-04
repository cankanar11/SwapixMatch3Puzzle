import Foundation

final class LevelSelectViewModel {
    let title = "Select Level"
    let levels = Level.allLevels
    
    private var stats: AllStatistics
    
    var unlockedLevels: Int {
        return StorageService.shared.unlockedLevels
    }
    
    init() {
        self.stats = StorageService.shared.loadStatistics()
    }
    
    func refresh() {
        self.stats = StorageService.shared.loadStatistics()
    }
    
    func isLevelUnlocked(_ level: Level) -> Bool {
        return level.id <= unlockedLevels
    }
    
    func getLevelInfo(_ level: Level) -> String {
        return "Target: \(level.targetScore)"
    }
    
    func getStars(for level: Level) -> Int {
        return stats.levelStats[level.id]?.bestStars ?? 0
    }
}
