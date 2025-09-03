//
//  HomeViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 27/08/25.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
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
        label.text = "Olá, sou o Lume e vou te ajudar a encontrar seu brilho!"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // utilizando classe InfoCardView
    
    private let cardMultiple: InfoCardView = {
        let card = InfoCardView()
        card.configure(
            iconName: "icon-book",
            title: "Múltiplas Inteligências",
            subtitle: "Um quiz que explora suas habilidades no teste de Howard Gardner."
        )
        return card
    }()
    
    private let cardResult: InfoCardView = {
        let card = InfoCardView()
        card.configure(
            iconName: "icon-compass",
            title: "Resultado as Inteligências",
            subtitle: "Veja o seu resultado e o seu tipo de inteligência mais desenvolvida."
        )
        return card
    }()

    private let cardProfessions: InfoCardView = {
        let card = InfoCardView()
        card.configure(
            iconName: "icon-star",
            title: "Sugestão de Profissões",
            subtitle: "Após o fim do teste é mostrado profissões que podem fazer sentido para você."
        )
        return card
    }()
    
    private let cardsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continuar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        speechBubbleView.addSubview(speechLabel)
        view.addSubview(fireflyImageView)
        view.addSubview(speechBubbleView)
        
        cardsStackView.addArrangedSubview(cardMultiple)
        cardsStackView.addArrangedSubview(cardResult)
        cardsStackView.addArrangedSubview(cardProfessions)

        view.addSubview(cardsStackView)
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
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
                
                // Texto do balão
                speechLabel.topAnchor.constraint(equalTo: speechBubbleView.topAnchor, constant: 12),
                speechLabel.bottomAnchor.constraint(equalTo: speechBubbleView.bottomAnchor, constant: -12),
                speechLabel.leadingAnchor.constraint(equalTo: speechBubbleView.leadingAnchor, constant: 12),
                speechLabel.trailingAnchor.constraint(equalTo: speechBubbleView.trailingAnchor, constant: -12),
                
                cardMultiple.heightAnchor.constraint(equalToConstant: 90),

                // StackView dos cards
                cardsStackView.topAnchor.constraint(equalTo: fireflyImageView.bottomAnchor, constant: 40),
                cardsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                cardsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                // Botão
                continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                continueButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapContinueButton() {
        print("Botão Continuar foi tocado!")
        let questionsVC = QuestionsViewController()
        
        // A forma mais comum de navegar é "empurrar" a nova tela na pilha de navegação.
        // Isso só funciona se a HomeViewController estiver dentro de um UINavigationController.
        let nav = UINavigationController(rootViewController: questionsVC)

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
