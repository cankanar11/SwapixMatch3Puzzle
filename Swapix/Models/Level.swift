import Foundation

struct Level {
    let id: Int
    let name: String
    let gridSize: Int
    let targetScore: Int
    let idealMoves: Int
    let backgroundName: String
    let gemTypes: Int
    
    func calculateStars(movesUsed: Int) -> Int {
        if movesUsed <= idealMoves {
            return 5
        } else if movesUsed <= Int(Double(idealMoves) * 1.3) {
            return 4
        } else if movesUsed <= Int(Double(idealMoves) * 1.6) {
            return 3
        } else if movesUsed <= Int(Double(idealMoves) * 2.0) {
            return 2
        } else if movesUsed <= Int(Double(idealMoves) * 2.5) {
            return 1
        } else {
            return 0
        }
    }
    
    static let allLevels: [Level] = [
        Level(id: 1, name: "Sunny Meadow", gridSize: 6, targetScore: 500, idealMoves: 12, backgroundName: "bg_meadow", gemTypes: 4),
        Level(id: 2, name: "Crystal Cave", gridSize: 6, targetScore: 800, idealMoves: 14, backgroundName: "bg_cave", gemTypes: 4),
        Level(id: 3, name: "Ocean Depths", gridSize: 7, targetScore: 1200, idealMoves: 16, backgroundName: "bg_ocean", gemTypes: 5),
        Level(id: 4, name: "Desert Storm", gridSize: 7, targetScore: 1500, idealMoves: 18, backgroundName: "bg_desert", gemTypes: 5),
        Level(id: 5, name: "Frozen Peaks", gridSize: 7, targetScore: 2000, idealMoves: 20, backgroundName: "bg_frozen", gemTypes: 5),
        Level(id: 6, name: "Volcano Core", gridSize: 8, targetScore: 2500, idealMoves: 22, backgroundName: "bg_volcano", gemTypes: 6),
        Level(id: 7, name: "Enchanted Forest", gridSize: 8, targetScore: 3000, idealMoves: 24, backgroundName: "bg_forest", gemTypes: 6),
        Level(id: 8, name: "Starlight Sky", gridSize: 8, targetScore: 3500, idealMoves: 26, backgroundName: "bg_starlight", gemTypes: 6),
        Level(id: 9, name: "Dragon Lair", gridSize: 9, targetScore: 4000, idealMoves: 28, backgroundName: "bg_dragon", gemTypes: 7),
        Level(id: 10, name: "Rainbow Kingdom", gridSize: 9, targetScore: 5000, idealMoves: 30, backgroundName: "bg_rainbow", gemTypes: 7)
    ]
}
