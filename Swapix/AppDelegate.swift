import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let launchViewModel = AppLaunchViewModel()
    private var shouldShowReviewOnLaunch = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        shouldShowReviewOnLaunch = launchViewModel.shouldShowReview
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        
        let loadingVC = LoadingViewController()
        window?.rootViewController = loadingVC
        window?.makeKeyAndVisible()
        
        launchViewModel.checkAndDetermineDestination { [weak self] destination, hadTokenOnLaunch in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch destination {
                case .content:
                    let contentVC = ContentDisplayViewController()
                    self.window?.rootViewController = contentVC
                    
                    if hadTokenOnLaunch && self.shouldShowReviewOnLaunch {
                        self.showReviewRequest()
                        self.launchViewModel.markReviewShown()
                    }
                    
                case .game:
                    let menuVC = MainMenuViewController()
                    self.window?.rootViewController = menuVC
                }
            }
        }
        
        return true
    }
    
    private func showReviewRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootVC = window?.rootViewController {
            if rootVC is ContentDisplayViewController {
                return .all
            }
            if let presented = rootVC.presentedViewController {
                if presented is ContentDisplayViewController {
                    return .all
                }
            }
        }
        return .portrait
    }
}


final class LoadingViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
