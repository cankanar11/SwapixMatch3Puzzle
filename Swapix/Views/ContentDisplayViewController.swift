import UIKit
import WebKit

final class ContentDisplayViewController: UIViewController {
    
    private let viewModel = ContentDisplayViewModel()
    private var contentView: WKWebView!
    private var isInitialLoad = true
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        setupLoadingView()
        loadContent()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupContentView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        contentView = WKWebView(frame: .zero, configuration: config)
        contentView.navigationDelegate = self
        contentView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.allowsBackForwardNavigationGestures = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isOpaque = false
        contentView.backgroundColor = .black
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    private func loadContent() {
        guard let address = viewModel.contentAddress,
              let contentAddress = URL(string: address) else { return }
        
        var request = URLRequest(url: contentAddress)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        contentView.load(request)
    }
    
    private func hideLoadingView() {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 0
        } completion: { _ in
            self.loadingView.isHidden = true
        }
    }
}

extension ContentDisplayViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isInitialLoad {
            isInitialLoad = false
            hideLoadingView()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if isInitialLoad {
            isInitialLoad = false
            hideLoadingView()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
