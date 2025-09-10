//
//  ResultsViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 03/09/25.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    
    private let testResponse: SubmitTestResponse
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background-home")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fireflyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firefly-book")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let speechBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let speechLabel: UILabel = {
        let label = UILabel()
        label.text = "Parabéns! Seus resultados chegaram."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Finalizar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(response: SubmitTestResponse) {
        self.testResponse = response
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureCardsWithResults()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(fireflyImageView)
        view.addSubview(speechBubbleView)
        speechBubbleView.addSubview(speechLabel)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(cardsStackView)
        
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Background
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Cabeçalho
            fireflyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fireflyImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fireflyImageView.widthAnchor.constraint(equalToConstant: 120),
            fireflyImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Balão de texto
            speechBubbleView.centerYAnchor.constraint(equalTo: fireflyImageView.centerYAnchor),
            speechBubbleView.leadingAnchor.constraint(equalTo: fireflyImageView.trailingAnchor, constant: 8),
            speechBubbleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            speechLabel.topAnchor.constraint(equalTo: speechBubbleView.topAnchor, constant: 12),
            speechLabel.bottomAnchor.constraint(equalTo: speechBubbleView.bottomAnchor, constant: -12),
            speechLabel.leadingAnchor.constraint(equalTo: speechBubbleView.leadingAnchor, constant: 12),
            speechLabel.trailingAnchor.constraint(equalTo: speechBubbleView.trailingAnchor, constant: -12),
            
            // Constraints para a ScrollView
            scrollView.topAnchor.constraint(equalTo: fireflyImageView.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            // Constraints para a StackView dentro da ScrollView
            cardsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            cardsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            cardsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            cardsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            cardsStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),

            // Botão
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Função para criar os cards dinamicamente
    private func configureCardsWithResults() {
        let intelligences = testResponse.intelligences
        let descriptions = testResponse.descriptions
        
        let scores = [
            (name: "Linguística", score: intelligences.linguistic, description: descriptions.linguistic, icon: "icon-book"),
            (name: "Lógico-Matemática", score: intelligences.logicalMathematical, description: descriptions.logicalMathematical, icon: "icon-compass"),
            (name: "Espacial", score: intelligences.spatial, description: descriptions.spatial, icon: "body-spatial-intelligence"),
            (name: "Musical", score: intelligences.musical, description: descriptions.musical, icon: "icon-book"),
            (name: "Cinestésico-Corporal", score: intelligences.bodilyKinesthetic, description: descriptions.bodilyKinesthetic, icon: "body-intelligence"),
            (name: "Naturalista", score: intelligences.naturalistic, description: descriptions.naturalistic, icon: "existential-intelligence"),
            (name: "Interpessoal", score: intelligences.interpersonal, description: descriptions.interpersonal, icon: "interpersonal-intelligence"),
            (name: "Intrapessoal", score: intelligences.intrapersonal, description: descriptions.intrapersonal, icon: "intrapersonal-intelligence")
             ]

        // Ordena a lista da maior pontuação para a menor
        let sortedScores = scores.sorted { $0.score > $1.score }

        // Cria e adiciona um card para cada inteligência
        for intelligence in sortedScores {
            let card = InfoCardView()
            card.configure(
                iconName: intelligence.icon,
                title: "\(intelligence.name): \(intelligence.score)%",
                subtitle: intelligence.description
            )
            cardsStackView.addArrangedSubview(card)
            
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive = true
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapContinueButton() {
        print("Botão Continuar foi tocado!")
        let dashboardVC = DashboardViewController()
        
        let nav = UINavigationController(rootViewController: dashboardVC)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = nav
            })
        }
    }
}
