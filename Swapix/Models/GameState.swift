import Foundation

enum GameResult {
    case playing
    case won
}

struct GameState {
    var currentScore: Int
    var movesUsed: Int
    var targetScore: Int
    var result: GameResult
    
    init(targetScore: Int) {
        self.currentScore = 0
        self.movesUsed = 0
        self.targetScore = targetScore
        self.result = .playing
    }
    
    mutating func addScore(_ points: Int) {
        currentScore += points
        checkGameEnd()
    }
    
    mutating func useMove() {
        movesUsed += 1
    }
    
    mutating func checkGameEnd() {
        if currentScore >= targetScore {
            result = .won
        }
    }
}
