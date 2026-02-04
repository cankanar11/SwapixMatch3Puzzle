import UIKit

final class StatisticsViewController: UIViewController {
    
    private let viewModel = StatisticsViewModel()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.15, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let summaryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalGamesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalStarsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let winRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateSummary()
        titleLabel.text = viewModel.title
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        view.addSubview(summaryView)
        summaryView.addSubview(totalGamesLabel)
        summaryView.addSubview(totalStarsLabel)
        summaryView.addSubview(winRateLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            summaryView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryView.heightAnchor.constraint(equalToConstant: 80),
            
            totalGamesLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),
            totalGamesLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 16),
            
            totalStarsLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),
            totalStarsLabel.topAnchor.constraint(equalTo: totalGamesLabel.bottomAnchor, constant: 8),
            
            winRateLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -16),
            winRateLabel.centerYAnchor.constraint(equalTo: summaryView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateSummary() {
        totalGamesLabel.text = "Total Games: \(viewModel.totalGamesPlayed)"
        totalStarsLabel.text = "Stars: \(viewModel.totalStars)/\(viewModel.maxStars) ★"
        winRateLabel.text = "Win Rate: \(viewModel.overallWinRate)"
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.levelDisplays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.identifier, for: indexPath) as? StatisticsCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.levelDisplays[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

final class StatisticsCell: UITableViewCell {
    static let identifier = "StatisticsCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let levelNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gamesPlayedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let winRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bestMovesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.3, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avgMovesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(levelNameLabel)
        containerView.addSubview(starsLabel)
        containerView.addSubview(gamesPlayedLabel)
        containerView.addSubview(winRateLabel)
        containerView.addSubview(bestMovesLabel)
        containerView.addSubview(avgMovesLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            levelNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            levelNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            starsLabel.centerYAnchor.constraint(equalTo: levelNameLabel.centerYAnchor),
            starsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            gamesPlayedLabel.topAnchor.constraint(equalTo: levelNameLabel.bottomAnchor, constant: 8),
            gamesPlayedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            winRateLabel.topAnchor.constraint(equalTo: levelNameLabel.bottomAnchor, constant: 8),
            winRateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            bestMovesLabel.topAnchor.constraint(equalTo: gamesPlayedLabel.bottomAnchor, constant: 8),
            bestMovesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            avgMovesLabel.topAnchor.constraint(equalTo: gamesPlayedLabel.bottomAnchor, constant: 8),
            avgMovesLabel.leadingAnchor.constraint(equalTo: bestMovesLabel.trailingAnchor, constant: 16)
        ])
    }
    
    func configure(with display: LevelStatisticsDisplay) {
        levelNameLabel.text = display.levelName
        starsLabel.text = display.bestStars
        gamesPlayedLabel.text = display.gamesPlayed
        winRateLabel.text = display.winRate
        bestMovesLabel.text = display.bestMoves
        avgMovesLabel.text = display.averageMoves
    }
}
