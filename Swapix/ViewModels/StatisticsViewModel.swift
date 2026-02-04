import Foundation

struct LevelStatisticsDisplay {
    let levelName: String
    let gamesPlayed: String
    let bestStars: String
    let winRate: String
    let bestMoves: String
    let averageMoves: String
}

final class StatisticsViewModel {
    let title = "Statistics"
    
    private var allStats: AllStatistics
    
    var levelDisplays: [LevelStatisticsDisplay] {
        return Level.allLevels.map { level in
            let stats = allStats.levelStats[level.id] ?? LevelStatistics(levelId: level.id)
            let starsDisplay = stats.bestStars > 0 ? String(repeating: "★", count: stats.bestStars) + String(repeating: "☆", count: 5 - stats.bestStars) : "☆☆☆☆☆"
            return LevelStatisticsDisplay(
                levelName: level.name,
                gamesPlayed: "Played: \(stats.gamesPlayed)",
                bestStars: starsDisplay,
                winRate: String(format: "Win Rate: %.1f%%", stats.winRate),
                bestMoves: stats.bestMoves > 0 ? "Best: \(stats.bestMoves) moves" : "Best: -",
                averageMoves: stats.averageMoves > 0 ? "Avg: \(stats.averageMoves) moves" : "Avg: -"
            )
        }
    }
    
    var totalGamesPlayed: Int {
        return allStats.levelStats.values.reduce(0) { $0 + $1.gamesPlayed }
    }
    
    var totalGamesWon: Int {
        return allStats.levelStats.values.reduce(0) { $0 + $1.gamesWon }
    }
    
    var overallWinRate: String {
        guard totalGamesPlayed > 0 else { return "0%" }
        let rate = Double(totalGamesWon) / Double(totalGamesPlayed) * 100
        return String(format: "%.1f%%", rate)
    }
    
    var totalStars: Int {
        return allStats.levelStats.values.reduce(0) { $0 + $1.bestStars }
    }
    
    var maxStars: Int {
        return Level.allLevels.count * 5
    }
    
    init() {
        self.allStats = StorageService.shared.loadStatistics()
    }
    
    func refresh() {
        self.allStats = StorageService.shared.loadStatistics()
    }
}
