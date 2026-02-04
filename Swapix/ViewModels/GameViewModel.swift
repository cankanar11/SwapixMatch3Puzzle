import Foundation

protocol GameViewModelDelegate: AnyObject {
    func didUpdateScore(_ score: Int)
    func didUpdateMoves(_ moves: Int)
    func didRemoveGems(at positions: [(row: Int, col: Int)])
    func didDropGems(moves: [(from: (row: Int, col: Int), to: (row: Int, col: Int))])
    func didAddNewGems(at positions: [(row: Int, col: Int)])
    func didSwapGems(from: (row: Int, col: Int), to: (row: Int, col: Int))
    func didRevertSwap(from: (row: Int, col: Int), to: (row: Int, col: Int))
    func didFinishGame(movesUsed: Int, stars: Int)
    func didShuffleBoard()
}

final class GameViewModel {
    weak var delegate: GameViewModelDelegate?
    
    private let level: Level
    private var gameState: GameState
    private var boardService: GameBoardService
    private var isProcessing = false
    private var selectedPosition: (row: Int, col: Int)?
    
    var gems: [[Gem?]] {
        return boardService.gems
    }
    
    var gridSize: Int {
        return level.gridSize
    }
    
    var currentScore: Int {
        return gameState.currentScore
    }
    
    var movesUsed: Int {
        return gameState.movesUsed
    }
    
    var targetScore: Int {
        return gameState.targetScore
    }
    
    var levelName: String {
        return level.name
    }
    
    var backgroundName: String {
        return level.backgroundName
    }
    
    var idealMoves: Int {
        return level.idealMoves
    }
    
    init(level: Level) {
        self.level = level
        self.gameState = GameState(targetScore: level.targetScore)
        self.boardService = GameBoardService(gridSize: level.gridSize, gemTypes: level.gemTypes)
    }
    
    func selectGem(at row: Int, col: Int) {
        guard !isProcessing else { return }
        
        if let selected = selectedPosition {
            if boardService.canSwap(from: selected, to: (row: row, col: col)) {
                performSwap(from: selected, to: (row: row, col: col))
            }
            selectedPosition = nil
        } else {
            selectedPosition = (row: row, col: col)
        }
    }
    
    private func performSwap(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        isProcessing = true
        
        boardService.swap(from: from, to: to)
        delegate?.didSwapGems(from: from, to: to)
        
        let matches = boardService.findMatches()
        
        if matches.isEmpty {
            boardService.swap(from: from, to: to)
            delegate?.didRevertSwap(from: from, to: to)
            isProcessing = false
        } else {
            gameState.useMove()
            delegate?.didUpdateMoves(gameState.movesUsed)
            processMatches()
        }
    }
    
    private func processMatches() {
        let matches = boardService.findMatches()
        
        if matches.isEmpty {
            checkGameState()
            return
        }
        
        let points = matches.count * 10
        gameState.addScore(points)
        delegate?.didUpdateScore(gameState.currentScore)
        
        boardService.removeMatches(matches)
        delegate?.didRemoveGems(at: matches)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.dropAndFill()
        }
    }
    
    private func dropAndFill() {
        let drops = boardService.dropGems()
        delegate?.didDropGems(moves: drops)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            let newGems = self.boardService.fillEmptySpaces()
            self.delegate?.didAddNewGems(at: newGems)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.processMatches()
            }
        }
    }
    
    private func checkGameState() {
        gameState.checkGameEnd()
        
        switch gameState.result {
        case .won:
            let stars = level.calculateStars(movesUsed: gameState.movesUsed)
            saveStatistics(won: true, stars: stars)
            StorageService.shared.unlockNextLevel(current: level.id)
            delegate?.didFinishGame(movesUsed: gameState.movesUsed, stars: stars)
        case .playing:
            if !boardService.hasValidMoves() {
                boardService.shuffleBoard()
                delegate?.didShuffleBoard()
            }
            isProcessing = false
        }
    }
    
    private func saveStatistics(won: Bool, stars: Int) {
        var stats = StorageService.shared.loadStatistics()
        stats.update(for: level.id, won: won, movesUsed: gameState.movesUsed, stars: stars)
        StorageService.shared.saveStatistics(stats)
    }
    
    func giveUp() {
        saveStatistics(won: false, stars: 0)
    }
}
