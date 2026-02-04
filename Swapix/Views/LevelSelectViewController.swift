import UIKit

final class LevelSelectViewController: UIViewController {
    
    private let viewModel = LevelSelectViewModel()
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(LevelCell.self, forCellWithReuseIdentifier: LevelCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleLabel.text = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
        collectionView.reloadData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        view.addSubview(collectionView)
        
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
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
}

extension LevelSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.identifier, for: indexPath) as? LevelCell else {
            return UICollectionViewCell()
        }
        
        let level = viewModel.levels[indexPath.item]
        let isUnlocked = viewModel.isLevelUnlocked(level)
        let info = viewModel.getLevelInfo(level)
        let stars = viewModel.getStars(for: level)
        cell.configure(level: level, isUnlocked: isUnlocked, info: info, stars: stars)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 56) / 2
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let level = viewModel.levels[indexPath.item]
        guard viewModel.isLevelUnlocked(level) else { return }
        
        let gameVC = GamePlayViewController(level: level)
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
}

final class LevelCell: UICollectionViewCell {
    static let identifier = "LevelCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let levelNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let levelNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "lock.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(levelNumberLabel)
        containerView.addSubview(levelNameLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(starsLabel)
        containerView.addSubview(lockImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            levelNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            levelNumberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            levelNameLabel.topAnchor.constraint(equalTo: levelNumberLabel.bottomAnchor, constant: 2),
            levelNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            levelNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            infoLabel.topAnchor.constraint(equalTo: levelNameLabel.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            starsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            starsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            lockImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            lockImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            lockImageView.widthAnchor.constraint(equalToConstant: 40),
            lockImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(level: Level, isUnlocked: Bool, info: String, stars: Int) {
        levelNumberLabel.text = "\(level.id)"
        levelNameLabel.text = level.name
        infoLabel.text = info
        
        let filled = String(repeating: "★", count: stars)
        let empty = String(repeating: "☆", count: 5 - stars)
        starsLabel.text = filled + empty
        
        let colors: [UIColor] = [
            UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1.0),
            UIColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 1.0),
            UIColor(red: 0.5, green: 0.3, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 1.0),
            UIColor(red: 0.4, green: 0.6, blue: 0.5, alpha: 1.0)
        ]
        
        let colorIndex = (level.id - 1) % colors.count
        containerView.backgroundColor = colors[colorIndex]
        
        if isUnlocked {
            lockImageView.isHidden = true
            levelNumberLabel.isHidden = false
            levelNameLabel.isHidden = false
            infoLabel.isHidden = false
            starsLabel.isHidden = false
            containerView.alpha = 1.0
        } else {
            lockImageView.isHidden = false
            levelNumberLabel.isHidden = true
            levelNameLabel.isHidden = false
            infoLabel.isHidden = true
            starsLabel.isHidden = true
            containerView.alpha = 0.5
        }
    }
}
