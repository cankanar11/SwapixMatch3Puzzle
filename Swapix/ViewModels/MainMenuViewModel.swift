import Foundation

final class MainMenuViewModel {
    let title = "Swapix"
    let playButtonTitle = "Play"
    let statisticsButtonTitle = "Statistics"
    let settingsButtonTitle = "Settings"
    
    var unlockedLevels: Int {
        return StorageService.shared.unlockedLevels
    }
    
    var totalLevels: Int {
        return Level.allLevels.count
    }
}
