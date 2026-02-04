import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier.lowercased()
    }
    
    private var systemLanguage: String {
        let language = Locale.preferredLanguages.first ?? "en"
        if let dashIndex = language.firstIndex(of: "-") {
            return String(language[..<dashIndex])
        }
        return language
    }
    
    private var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    private var countryCode: String {
        return Locale.current.region?.identifier ?? "US"
    }
    
    func checkAccess(completion: @escaping (Result<(token: String, address: String)?, Error>) -> Void) {
        let baseAddress = "https://aprulestext.site/ios-swapix-matchpuzzle/server.php"
        let params = "p=Bs2675kDjkb5Ga&os=\(systemVersion)&lng=\(systemLanguage)&devicemodel=\(deviceModel)&country=\(countryCode)"
        
        guard let requestAddress = Foundation.URL(string: "\(baseAddress)?\(params)") else {
            completion(.failure(NSError(domain: "InvalidAddress", code: -1)))
            return
        }
        
        var request = URLRequest(url: requestAddress)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30
        
        URLCache.shared.removeAllCachedResponses()
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.success(nil))
                return
            }
            
            let trimmed = responseString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmed.contains("#") {
                let parts = trimmed.components(separatedBy: "#")
                if parts.count >= 2 {
                    let token = parts[0]
                    let address = parts[1]
                    completion(.success((token: token, address: address)))
                } else {
                    completion(.success(nil))
                }
            } else {
                completion(.success(nil))
            }
        }.resume()
    }
}
