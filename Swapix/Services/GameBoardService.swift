import Foundation

final class GameBoardService {
    private var board: [[Gem?]]
    private let gridSize: Int
    private let gemTypes: Int
    
    init(gridSize: Int, gemTypes: Int) {
        self.gridSize = gridSize
        self.gemTypes = gemTypes
        self.board = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        fillBoard()
    }
    
    var gems: [[Gem?]] {
        return board
    }
    
    private func fillBoard() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                var gemType: GemType
                repeat {
                    gemType = GemType.random(maxTypes: gemTypes)
                } while wouldCreateMatch(row: row, col: col, type: gemType)
                board[row][col] = Gem(type: gemType, row: row, column: col)
            }
        }
    }
    
    private func wouldCreateMatch(row: Int, col: Int, type: GemType) -> Bool {
        if col >= 2 {
            if board[row][col - 1]?.type == type && board[row][col - 2]?.type == type {
                return true
            }
        }
        if row >= 2 {
            if board[row - 1][col]?.type == type && board[row - 2][col]?.type == type {
                return true
            }
        }
        return false
    }
    
    func canSwap(from: (row: Int, col: Int), to: (row: Int, col: Int)) -> Bool {
        let rowDiff = abs(from.row - to.row)
        let colDiff = abs(from.col - to.col)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    func swap(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        let temp = board[from.row][from.col]
        board[from.row][from.col] = board[to.row][to.col]
        board[to.row][to.col] = temp
        
        board[from.row][from.col]?.row = from.row
        board[from.row][from.col]?.column = from.col
        board[to.row][to.col]?.row = to.row
        board[to.row][to.col]?.column = to.col
    }
    
    func findMatches() -> [(row: Int, col: Int)] {
        var matchedPositions: Set<String> = []
        
        for row in 0..<gridSize {
            var matchStart = 0
            for col in 1..<gridSize {
                if board[row][col]?.type == board[row][matchStart]?.type {
                    if col == gridSize - 1 && col - matchStart >= 2 {
                        for i in matchStart...col {
                            matchedPositions.insert("\(row),\(i)")
                        }
                    }
                } else {
                    if col - matchStart >= 3 {
                        for i in matchStart..<col {
                            matchedPositions.insert("\(row),\(i)")
                        }
                    }
                    matchStart = col
                }
            }
        }
        
        for col in 0..<gridSize {
            var matchStart = 0
            for row in 1..<gridSize {
                if board[row][col]?.type == board[matchStart][col]?.type {
                    if row == gridSize - 1 && row - matchStart >= 2 {
                        for i in matchStart...row {
                            matchedPositions.insert("\(i),\(col)")
                        }
                    }
                } else {
                    if row - matchStart >= 3 {
                        for i in matchStart..<row {
                            matchedPositions.insert("\(i),\(col)")
                        }
                    }
                    matchStart = row
                }
            }
        }
        
        return matchedPositions.compactMap { str in
            let parts = str.split(separator: ",")
            guard parts.count == 2,
                  let row = Int(parts[0]),
                  let col = Int(parts[1]) else { return nil }
            return (row: row, col: col)
        }
    }
    
    func removeMatches(_ positions: [(row: Int, col: Int)]) {
        for pos in positions {
            board[pos.row][pos.col] = nil
        }
    }
    
    func dropGems() -> [(from: (row: Int, col: Int), to: (row: Int, col: Int))] {
        var moves: [(from: (row: Int, col: Int), to: (row: Int, col: Int))] = []
        
        for col in 0..<gridSize {
            var emptyRow = gridSize - 1
            for row in stride(from: gridSize - 1, through: 0, by: -1) {
                if board[row][col] != nil {
                    if row != emptyRow {
                        board[emptyRow][col] = board[row][col]
                        board[emptyRow][col]?.row = emptyRow
                        board[row][col] = nil
                        moves.append((from: (row: row, col: col), to: (row: emptyRow, col: col)))
                    }
                    emptyRow -= 1
                }
            }
        }
        
        return moves
    }
    
    func fillEmptySpaces() -> [(row: Int, col: Int)] {
        var newGems: [(row: Int, col: Int)] = []
        
        for col in 0..<gridSize {
            for row in 0..<gridSize {
                if board[row][col] == nil {
                    let gemType = GemType.random(maxTypes: gemTypes)
                    board[row][col] = Gem(type: gemType, row: row, column: col)
                    newGems.append((row: row, col: col))
                }
            }
        }
        
        return newGems
    }
    
    func hasValidMoves() -> Bool {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if col < gridSize - 1 {
                    swap(from: (row: row, col: col), to: (row: row, col: col + 1))
                    let matches = findMatches()
                    swap(from: (row: row, col: col), to: (row: row, col: col + 1))
                    if !matches.isEmpty { return true }
                }
                if row < gridSize - 1 {
                    swap(from: (row: row, col: col), to: (row: row + 1, col: col))
                    let matches = findMatches()
                    swap(from: (row: row, col: col), to: (row: row + 1, col: col))
                    if !matches.isEmpty { return true }
                }
            }
        }
        return false
    }
    
    func shuffleBoard() {
        var allGems: [Gem] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if let gem = board[row][col] {
                    allGems.append(gem)
                }
            }
        }
        
        allGems.shuffle()
        
        var index = 0
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if index < allGems.count {
                    board[row][col] = allGems[index]
                    board[row][col]?.row = row
                    board[row][col]?.column = col
                    index += 1
                }
            }
        }
        
        while !findMatches().isEmpty || !hasValidMoves() {
            fillBoard()
        }
    }
}
