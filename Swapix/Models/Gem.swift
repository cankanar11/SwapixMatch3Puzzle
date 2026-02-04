import UIKit

enum GemType: Int, CaseIterable {
    case ruby = 0
    case sapphire = 1
    case emerald = 2
    case topaz = 3
    case amethyst = 4
    case diamond = 5
    case obsidian = 6
    
    var color: UIColor {
        switch self {
        case .ruby: return UIColor(red: 0.9, green: 0.1, blue: 0.2, alpha: 1.0)
        case .sapphire: return UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1.0)
        case .emerald: return UIColor(red: 0.1, green: 0.8, blue: 0.3, alpha: 1.0)
        case .topaz: return UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        case .amethyst: return UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        case .diamond: return UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
        case .obsidian: return UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0)
        }
    }
    
    var symbol: String {
        switch self {
        case .ruby: return "♦️"
        case .sapphire: return "💎"
        case .emerald: return "💚"
        case .topaz: return "⭐"
        case .amethyst: return "🔮"
        case .diamond: return "💠"
        case .obsidian: return "🖤"
        }
    }
    
    static func random(maxTypes: Int) -> GemType {
        let availableTypes = min(maxTypes, GemType.allCases.count)
        let randomIndex = Int.random(in: 0..<availableTypes)
        return GemType(rawValue: randomIndex) ?? .ruby
    }
}

class Gem: Equatable {
    var type: GemType
    var row: Int
    var column: Int
    var isMatched: Bool = false
    
    init(type: GemType, row: Int, column: Int) {
        self.type = type
        self.row = row
        self.column = column
    }
    
    static func == (lhs: Gem, rhs: Gem) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column && lhs.type == rhs.type
    }
}
