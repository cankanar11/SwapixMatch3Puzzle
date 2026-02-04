import Foundation

final class ContentDisplayViewModel {
    private let storage = StorageService.shared
    
    var contentAddress: String? {
        return storage.contentAddress
    }
    
    var hasValidAddress: Bool {
        guard let address = contentAddress, !address.isEmpty else { return false }
        return true
    }
}
