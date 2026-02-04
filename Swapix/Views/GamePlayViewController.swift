import UIKit

final class GamePlayViewController: UIViewController {
    
    private var viewModel: GameViewModel
    private var gemViews: [[UIView?]] = []
    private var selectedGemView: UIView?
    private var boardView: UIView!
    private var gemSize: CGFloat = 0
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let levelNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idealMovesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(level: Level) {
        self.viewModel = GameViewModel(level: level)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        setupBoard()
        updateLabels()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(levelNameLabel)
        headerView.addSubview(scoreLabel)
        headerView.addSubview(targetLabel)
        headerView.addSubview(movesLabel)
        headerView.addSubview(idealMovesLabel)
        
        applyBackground()
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            levelNameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            levelNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            scoreLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            scoreLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            
            targetLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            targetLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),
            
            movesLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            movesLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            
            idealMovesLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            idealMovesLabel.topAnchor.constraint(equalTo: movesLabel.bottomAnchor, constant: 4)
        ])
        
        levelNameLabel.text = viewModel.levelName
    }
    
    private func applyBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let backgrounds: [String: [CGColor]] = [
            "bg_meadow": [UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 1.0).cgColor, UIColor(red: 0.1, green: 0.4, blue: 0.2, alpha: 1.0).cgColor],
            "bg_cave": [UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor, UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor],
            "bg_ocean": [UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1.0).cgColor, UIColor(red: 0.05, green: 0.15, blue: 0.3, alpha: 1.0).cgColor],
            "bg_desert": [UIColor(red: 0.8, green: 0.6, blue: 0.3, alpha: 1.0).cgColor, UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0).cgColor],
            "bg_frozen": [UIColor(red: 0.6, green: 0.8, blue: 0.9, alpha: 1.0).cgColor, UIColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 1.0).cgColor],
            "bg_volcano": [UIColor(red: 0.6, green: 0.2, blue: 0.1, alpha: 1.0).cgColor, UIColor(red: 0.3, green: 0.1, blue: 0.05, alpha: 1.0).cgColor],
            "bg_forest": [UIColor(red: 0.1, green: 0.4, blue: 0.2, alpha: 1.0).cgColor, UIColor(red: 0.05, green: 0.2, blue: 0.1, alpha: 1.0).cgColor],
            "bg_starlight": [UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0).cgColor, UIColor(red: 0.0, green: 0.0, blue: 0.1, alpha: 1.0).cgColor],
            "bg_dragon": [UIColor(red: 0.4, green: 0.1, blue: 0.1, alpha: 1.0).cgColor, UIColor(red: 0.2, green: 0.05, blue: 0.05, alpha: 1.0).cgColor],
            "bg_rainbow": [UIColor(red: 0.5, green: 0.3, blue: 0.6, alpha: 1.0).cgColor, UIColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 1.0).cgColor]
        ]
        
        gradientLayer.colors = backgrounds[viewModel.backgroundName] ?? backgrounds["bg_meadow"]!
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupBoard() {
        let gridSize = viewModel.gridSize
        let padding: CGFloat = 16
        let boardWidth = view.bounds.width - padding * 2
        gemSize = (boardWidth - CGFloat(gridSize + 1) * 4) / CGFloat(gridSize)
        
        boardView = UIView()
        boardView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        boardView.layer.cornerRadius = 16
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        let boardHeight = gemSize * CGFloat(gridSize) + CGFloat(gridSize + 1) * 4
        
        NSLayoutConstraint.activate([
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            boardView.widthAnchor.constraint(equalToConstant: boardWidth),
            boardView.heightAnchor.constraint(equalToConstant: boardHeight)
        ])
        
        gemViews = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        
        view.layoutIfNeeded()
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if let gem = viewModel.gems[row][col] {
                    let gemView = createGemView(for: gem, row: row, col: col)
                    boardView.addSubview(gemView)
                    gemViews[row][col] = gemView
                }
            }
        }
    }
    
    private func createGemView(for gem: Gem, row: Int, col: Int) -> UIView {
        let x = 4 + CGFloat(col) * (gemSize + 4)
        let y = 4 + CGFloat(row) * (gemSize + 4)
        
        let gemView = UIView(frame: CGRect(x: x, y: y, width: gemSize, height: gemSize))
        gemView.backgroundColor = gem.type.color
        gemView.layer.cornerRadius = gemSize / 4
        gemView.layer.shadowColor = UIColor.black.cgColor
        gemView.layer.shadowOffset = CGSize(width: 0, height: 2)
        gemView.layer.shadowRadius = 4
        gemView.layer.shadowOpacity = 0.3
        gemView.tag = row * 100 + col
        
        let label = UILabel(frame: gemView.bounds)
        label.text = gem.type.symbol
        label.font = UIFont.systemFont(ofSize: gemSize * 0.5)
        label.textAlignment = .center
        gemView.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gemTapped(_:)))
        gemView.addGestureRecognizer(tap)
        gemView.isUserInteractionEnabled = true
        
        return gemView
    }
    
    private func updateLabels() {
        scoreLabel.text = "Score: \(viewModel.currentScore)"
        targetLabel.text = "Target: \(viewModel.targetScore)"
        movesLabel.text = "Moves: \(viewModel.movesUsed)"
        idealMovesLabel.text = "Ideal: \(viewModel.idealMoves)"
    }
    
    @objc private func gemTapped(_ gesture: UITapGestureRecognizer) {
        guard let gemView = gesture.view else { return }
        let row = gemView.tag / 100
        let col = gemView.tag % 100
        
        if selectedGemView == nil {
            selectedGemView = gemView
            UIView.animate(withDuration: 0.15) {
                gemView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        } else if selectedGemView === gemView {
            UIView.animate(withDuration: 0.15) {
                gemView.transform = .identity
            }
            selectedGemView = nil
        } else {
            UIView.animate(withDuration: 0.15) {
                self.selectedGemView?.transform = .identity
            }
            selectedGemView = nil
            viewModel.selectGem(at: row, col: col)
        }
        
        viewModel.selectGem(at: row, col: col)
    }
    
    @objc private func backTapped() {
        let alert = UIAlertController(title: "Give Up?", message: "Are you sure you want to quit? This will count as a loss.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Give Up", style: .destructive) { [weak self] _ in
            self?.viewModel.giveUp()
            self?.dismiss(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func starsString(_ count: Int) -> String {
        let filled = String(repeating: "★", count: count)
        let empty = String(repeating: "☆", count: 5 - count)
        return filled + empty
    }
    
    private func showGameOverAlert(movesUsed: Int, stars: Int) {
        let title = "Level Complete!"
        let starsDisplay = starsString(stars)
        let message = "\(starsDisplay)\n\nMoves used: \(movesUsed)\nIdeal: \(viewModel.idealMoves)"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Next Level", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Menu", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func positionForGem(row: Int, col: Int) -> CGPoint {
        let x = 4 + CGFloat(col) * (gemSize + 4) + gemSize / 2
        let y = 4 + CGFloat(row) * (gemSize + 4) + gemSize / 2
        return CGPoint(x: x, y: y)
    }
}

extension GamePlayViewController: GameViewModelDelegate {
    func didUpdateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func didUpdateMoves(_ moves: Int) {
        movesLabel.text = "Moves: \(moves)"
    }
    
    func didRemoveGems(at positions: [(row: Int, col: Int)]) {
        for pos in positions {
            if let gemView = gemViews[pos.row][pos.col] {
                UIView.animate(withDuration: 0.2, animations: {
                    gemView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    gemView.alpha = 0
                }) { _ in
                    gemView.removeFromSuperview()
                }
                gemViews[pos.row][pos.col] = nil
            }
        }
    }
    
    func didDropGems(moves: [(from: (row: Int, col: Int), to: (row: Int, col: Int))]) {
        for move in moves {
            if let gemView = gemViews[move.from.row][move.from.col] {
                gemViews[move.to.row][move.to.col] = gemView
                gemViews[move.from.row][move.from.col] = nil
                gemView.tag = move.to.row * 100 + move.to.col
                
                let newPosition = positionForGem(row: move.to.row, col: move.to.col)
                UIView.animate(withDuration: 0.2) {
                    gemView.center = newPosition
                }
            }
        }
    }
    
    func didAddNewGems(at positions: [(row: Int, col: Int)]) {
        for pos in positions {
            if let gem = viewModel.gems[pos.row][pos.col] {
                let gemView = createGemView(for: gem, row: pos.row, col: pos.col)
                gemView.alpha = 0
                gemView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                boardView.addSubview(gemView)
                gemViews[pos.row][pos.col] = gemView
                
                UIView.animate(withDuration: 0.2) {
                    gemView.alpha = 1
                    gemView.transform = .identity
                }
            }
        }
    }
    
    func didSwapGems(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        let fromView = gemViews[from.row][from.col]
        let toView = gemViews[to.row][to.col]
        
        gemViews[from.row][from.col] = toView
        gemViews[to.row][to.col] = fromView
        
        fromView?.tag = to.row * 100 + to.col
        toView?.tag = from.row * 100 + from.col
        
        let fromPos = positionForGem(row: from.row, col: from.col)
        let toPos = positionForGem(row: to.row, col: to.col)
        
        UIView.animate(withDuration: 0.2) {
            fromView?.center = toPos
            toView?.center = fromPos
        }
    }
    
    func didRevertSwap(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.didSwapGems(from: from, to: to)
        }
    }
    
    func didFinishGame(movesUsed: Int, stars: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showGameOverAlert(movesUsed: movesUsed, stars: stars)
        }
    }
    
    func didShuffleBoard() {
        for row in gemViews {
            for gemView in row {
                gemView?.removeFromSuperview()
            }
        }
        
        let gridSize = viewModel.gridSize
        gemViews = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if let gem = viewModel.gems[row][col] {
                    let gemView = createGemView(for: gem, row: row, col: col)
                    boardView.addSubview(gemView)
                    gemViews[row][col] = gemView
                }
            }
        }
    }
}
