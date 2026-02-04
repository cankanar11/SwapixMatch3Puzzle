import UIKit

final class MainMenuViewController: UIViewController {
    
    private let viewModel = MainMenuViewModel()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.18, alpha: 1.0)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gemsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 52, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = createMenuButton(title: viewModel.playButtonTitle, color: UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0))
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var statisticsButton: UIButton = {
        let button = createMenuButton(title: viewModel.statisticsButtonTitle, color: UIColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 1.0))
        button.addTarget(self, action: #selector(statisticsTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addFloatingGems()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(gemsContainer)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(playButton)
        buttonsStack.addArrangedSubview(statisticsButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gemsContainer.topAnchor.constraint(equalTo: view.topAnchor),
            gemsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gemsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gemsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            playButton.heightAnchor.constraint(equalToConstant: 56),
            statisticsButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        addGradientBackground()
    }
    
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.25, alpha: 1.0).cgColor,
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureContent() {
        titleLabel.text = viewModel.title
        subtitleLabel.text = "Levels: \(viewModel.unlockedLevels)/\(viewModel.totalLevels)"
    }
    
    private func createMenuButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = color
        button.layer.cornerRadius = 28
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func addFloatingGems() {
        gemsContainer.subviews.forEach { $0.removeFromSuperview() }
        
        let gemData: [(color: UIColor, symbol: String)] = [
            (UIColor(red: 0.9, green: 0.1, blue: 0.2, alpha: 1.0), "♦️"),
            (UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1.0), "💎"),
            (UIColor(red: 0.1, green: 0.8, blue: 0.3, alpha: 1.0), "💚"),
            (UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), "⭐"),
            (UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0), "🔮"),
            (UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0), "💠")
        ]
        
        let positions: [(x: CGFloat, y: CGFloat, size: CGFloat)] = [
            (0.1, 0.15, 50),
            (0.85, 0.12, 45),
            (0.15, 0.35, 40),
            (0.9, 0.32, 48),
            (0.08, 0.75, 44),
            (0.88, 0.7, 42),
            (0.2, 0.88, 38),
            (0.75, 0.85, 46),
            (0.5, 0.08, 35),
            (0.55, 0.92, 40),
            (0.3, 0.55, 32),
            (0.7, 0.52, 36)
        ]
        
        for (index, pos) in positions.enumerated() {
            let gem = gemData[index % gemData.count]
            let gemView = createGemView(color: gem.color, symbol: gem.symbol, size: pos.size)
            
            let x = view.bounds.width * pos.x - pos.size / 2
            let y = view.bounds.height * pos.y - pos.size / 2
            gemView.frame = CGRect(x: x, y: y, width: pos.size, height: pos.size)
            gemView.alpha = 0.7
            
            gemsContainer.addSubview(gemView)
            animateGem(gemView, index: index)
        }
    }
    
    private func createGemView(color: UIColor, symbol: String, size: CGFloat) -> UIView {
        let gemView = UIView()
        gemView.backgroundColor = color
        gemView.layer.cornerRadius = size / 4
        gemView.layer.shadowColor = color.cgColor
        gemView.layer.shadowOffset = CGSize(width: 0, height: 2)
        gemView.layer.shadowRadius = 8
        gemView.layer.shadowOpacity = 0.6
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
        label.text = symbol
        label.font = UIFont.systemFont(ofSize: size * 0.5)
        label.textAlignment = .center
        gemView.addSubview(label)
        
        return gemView
    }
    
    private func animateGem(_ gemView: UIView, index: Int) {
        let duration = Double.random(in: 2.5...4.5)
        let delay = Double(index) * 0.15
        let moveY = CGFloat.random(in: 15...30)
        let rotation = CGFloat.random(in: -0.15...0.15)
        
        gemView.transform = CGAffineTransform(rotationAngle: -rotation)
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.repeat, .autoreverse, .curveEaseInOut]
        ) {
            gemView.transform = CGAffineTransform(translationX: 0, y: -moveY)
                .rotated(by: rotation)
            gemView.alpha = 0.9
        }
        
        addPulseEffect(to: gemView, delay: delay)
    }
    
    private func addPulseEffect(to view: UIView, delay: Double) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = Double.random(in: 1.5...2.5)
        pulse.fromValue = 1.0
        pulse.toValue = 1.08
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.beginTime = CACurrentMediaTime() + delay
        view.layer.add(pulse, forKey: "pulse")
    }
    
    @objc private func playTapped() {
        let levelSelectVC = LevelSelectViewController()
        levelSelectVC.modalPresentationStyle = .fullScreen
        present(levelSelectVC, animated: true)
    }
    
    @objc private func statisticsTapped() {
        let statsVC = StatisticsViewController()
        statsVC.modalPresentationStyle = .fullScreen
        present(statsVC, animated: true)
    }
}
