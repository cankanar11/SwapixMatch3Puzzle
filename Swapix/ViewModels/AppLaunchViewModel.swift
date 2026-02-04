import Foundation

enum LaunchDestination {
    case content
    case game
}

final class AppLaunchViewModel {
    private let storage = StorageService.shared
    private let network = NetworkService.shared
    
    var hasStoredToken: Bool {
        return storage.hasToken
    }
    
    var shouldShowReview: Bool {
        return hasStoredToken && !storage.reviewShown
    }
    
    func markReviewShown() {
        storage.reviewShown = true
    }
    
    func checkAndDetermineDestination(completion: @escaping (LaunchDestination, Bool) -> Void) {
        if storage.hasToken {
            completion(.content, true)
            return
        }
        
        network.checkAccess { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, !data.token.isEmpty, !data.address.isEmpty {
                        StorageService.shared.accessToken = data.token
                        StorageService.shared.contentAddress = data.address
                        completion(.content, false)
                    } else {
                        completion(.game, false)
                    }
                case .failure:
                    completion(.game, false)
                }
            }
        }
    }
}
