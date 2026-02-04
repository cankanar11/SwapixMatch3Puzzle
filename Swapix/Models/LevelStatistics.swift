import Foundation

struct LevelStatistics: Codable {
    let levelId: Int
    var gamesPlayed: Int
    var gamesWon: Int
    var bestMoves: Int
    var bestStars: Int
    var totalMoves: Int
    
    var winRate: Double {
        guard gamesPlayed > 0 else { return 0 }
        return Double(gamesWon) / Double(gamesPlayed) * 100
    }
    
    var averageMoves: Int {
        guard gamesWon > 0 else { return 0 }
        return totalMoves / gamesWon
    }
    
    init(levelId: Int) {
        self.levelId = levelId
        self.gamesPlayed = 0
        self.gamesWon = 0
        self.bestMoves = 0
        self.bestStars = 0
        self.totalMoves = 0
    }
}

struct AllStatistics: Codable {
    var levelStats: [Int: LevelStatistics]
    
    init() {
        self.levelStats = [:]
    }
    
    mutating func getOrCreate(for levelId: Int) -> LevelStatistics {
        if let stats = levelStats[levelId] {
            return stats
        }
        let newStats = LevelStatistics(levelId: levelId)
        levelStats[levelId] = newStats
        return newStats
    }
    
    mutating func update(for levelId: Int, won: Bool, movesUsed: Int, stars: Int) {
        var stats = getOrCreate(for: levelId)
        stats.gamesPlayed += 1
        if won {
            stats.gamesWon += 1
            stats.totalMoves += movesUsed
            if stats.bestMoves == 0 || movesUsed < stats.bestMoves {
                stats.bestMoves = movesUsed
            }
            if stars > stats.bestStars {
                stats.bestStars = stars
            }
        }
        levelStats[levelId] = stats
    }
}
