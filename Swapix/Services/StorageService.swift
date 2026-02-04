import Foundation

final class StorageService {
    static let shared = StorageService()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let accessToken = "access_token_key"
        static let contentAddress = "content_address_key"
        static let statistics = "game_statistics_key"
        static let unlockedLevels = "unlocked_levels_key"
        static let reviewShown = "review_shown_key"
    }
    
    private init() {}
    
    var accessToken: String? {
        get { defaults.string(forKey: Keys.accessToken) }
        set {
            defaults.set(newValue, forKey: Keys.accessToken)
            defaults.synchronize()
        }
    }
    
    var contentAddress: String? {
        get { defaults.string(forKey: Keys.contentAddress) }
        set {
            defaults.set(newValue, forKey: Keys.contentAddress)
            defaults.synchronize()
        }
    }
    
    var hasToken: Bool {
        guard let token = accessToken, let address = contentAddress else { return false }
        return !token.isEmpty && !address.isEmpty
    }
    
    var reviewShown: Bool {
        get { defaults.bool(forKey: Keys.reviewShown) }
        set { defaults.set(newValue, forKey: Keys.reviewShown) }
    }
    
    func saveStatistics(_ stats: AllStatistics) {
        if let data = try? JSONEncoder().encode(stats) {
            defaults.set(data, forKey: Keys.statistics)
        }
    }
    
    func loadStatistics() -> AllStatistics {
        guard let data = defaults.data(forKey: Keys.statistics),
              let stats = try? JSONDecoder().decode(AllStatistics.self, from: data) else {
            return AllStatistics()
        }
        return stats
    }
    
    var unlockedLevels: Int {
        get {
            let value = defaults.integer(forKey: Keys.unlockedLevels)
            return value == 0 ? 1 : value
        }
        set { defaults.set(newValue, forKey: Keys.unlockedLevels) }
    }
    
    func unlockNextLevel(current: Int) {
        if current >= unlockedLevels && current < Level.allLevels.count {
            unlockedLevels = current + 1
        }
    }
    
    func clearAll() {
        defaults.removeObject(forKey: Keys.accessToken)
        defaults.removeObject(forKey: Keys.contentAddress)
        defaults.removeObject(forKey: Keys.statistics)
        defaults.removeObject(forKey: Keys.unlockedLevels)
        defaults.removeObject(forKey: Keys.reviewShown)
    }
}
