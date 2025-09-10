//
//  DashboardViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 09/09/25.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModel
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "background-home"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fireflyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "firefly-book"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let speechBubbleView: SpeechBubbleView = {
        let view = SpeechBubbleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle

    init(viewModel: DashboardViewModel = DashboardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindViewModel()
        viewModel.loadUserProfile()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .red

        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(fireflyImageView)
        contentView.addSubview(speechBubbleView)
        contentView.addSubview(mainStackView)
        
        view.addSubview(activityIndicator)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            fireflyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            fireflyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fireflyImageView.widthAnchor.constraint(equalToConstant: 100),
            fireflyImageView.heightAnchor.constraint(equalToConstant: 100),

            speechBubbleView.centerYAnchor.constraint(equalTo: fireflyImageView.centerYAnchor),
            speechBubbleView.leadingAnchor.constraint(equalTo: fireflyImageView.trailingAnchor, constant: 8),
            speechBubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            mainStackView.topAnchor.constraint(equalTo: fireflyImageView.bottomAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .loading:
                self?.activityIndicator.startAnimating()
                self?.mainStackView.isHidden = true
            case .success(let data):
                self?.activityIndicator.stopAnimating()
                self?.mainStackView.isHidden = false
                self?.populateUI(with: data)
            case .error(let message):
                self?.activityIndicator.stopAnimating()
                self?.showError(message)
            }
        }
        
        viewModel.onLogout = { [weak self] in
             let loginVC = LoginViewController()
             if let window = self?.view.window {
                 window.rootViewController = UINavigationController(rootViewController: loginVC)
                 UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
             }
            print("Navegando para a tela de login...")
        }
    }
    
    // MARK: - UI Population
    
    private func populateUI(with data: DashboardResponse) {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let firstName = data.user.fullName.components(separatedBy: " ").first ?? ""
        speechBubbleView.configure(with: "Olá, \(firstName)! Aqui está um resumo do seu perfil.")
        
        let intelligencesCard = createSectionCard(
            title: "Seu Teste de Inteligência",
            subtitle: "Realizado em: \(formatDate(data.intelligenceTest.testDate))"
        )
        
        let intelligenceStack = createIntelligenceStack(from: data.intelligenceTest.intelligences)
        intelligencesCard.addContent(intelligenceStack)
        mainStackView.addArrangedSubview(intelligencesCard)

        let suggestionsCard = createSectionCard(title: "Sugestões de Carreira para Você")
        let suggestionsStack = createSuggestionsStack(from: data.areaSuggestions)
        suggestionsCard.addContent(suggestionsStack)
        mainStackView.addArrangedSubview(suggestionsCard)
    }

    // MARK: - Actions
    
    @objc private func logoutButtonTapped() {
        viewModel.handleLogout()
    }
    
    // MARK: - Helpers
    
    private func createSectionCard(title: String, subtitle: String? = nil) -> SectionCardView {
        let card = SectionCardView()
        card.configure(title: title, subtitle: subtitle)
        return card
    }
    
    private func createIntelligenceStack(from intelligences: IntelligenceTest.Intelligences) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        let topIntelligence = intelligences.all.sorted { $0.value > $1.value }.first
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Sua inteligência principal é: \(topIntelligence?.key.capitalized ?? "") (\(topIntelligence?.value ?? 0)%)"
        label.textColor = .darkGray
        stack.addArrangedSubview(label)
        return stack
    }
    
    private func createSuggestionsStack(from suggestions: [AreaSuggestion]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        for suggestion in suggestions {
            let view = SuggestionView()
            view.configure(
                area: suggestion.area,
                probability: suggestion.probability,
                professions: suggestion.sampleProfessions
            )
            stack.addArrangedSubview(view)
        }
        return stack
    }

    private func showError(_ message: String) {
        speechBubbleView.configure(with: message)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .long
            displayFormatter.locale = Locale(identifier: "pt_BR")
            return displayFormatter.string(from: date)
        }
        return "Data desconhecida"
    }
}

class SpeechBubbleView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 12
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with text: String) {
        label.text = text
    }
}

class SectionCardView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var contentContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 16
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(subtitleLabel)
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(title: String, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
    }
    
    func addContent(_ view: UIView) {
        mainStack.addArrangedSubview(UIView()) // Spacer
        mainStack.setCustomSpacing(12, after: subtitleLabel.isHidden ? titleLabel : subtitleLabel)
        mainStack.addArrangedSubview(view)
    }
}

class SuggestionView: UIView {
    private let areaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    private let probabilityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    private let professionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let topStack = UIStackView(arrangedSubviews: [areaLabel, probabilityLabel])
        topStack.distribution = .equalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [topStack, professionsLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(area: String, probability: String, professions: [String]) {
        areaLabel.text = area
        probabilityLabel.text = probability
        professionsLabel.text = "Ex: " + professions.joined(separator: ", ")
    }
}
