//
//  LoginViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 25/08/25.
//

import UIKit

// ViewController para a tela de apresentação/login inicial.
class LoginViewController: UIViewController {

    // MARK: - UI Components

    // Imagem principal com o mascote (vagalume).
    private let fireflyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firefly")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Imagem do logo "Luminar".
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "luminar-logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Texto do slogan.
    private let sloganLabel: UILabel = {
        let label = UILabel()
        label.text = "Venha com o Lume descobrir o seu brilho"
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // StackView para organizar os elementos verticalmente.
    // Usar uma StackView simplifica o layout e evita conflitos de constraints.
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0 // Espaçamento padrão entre os elementos.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        // Define a cor de fundo da tela.
        view.backgroundColor = UIColor(named: "background")
        
        // Adiciona a StackView principal à view.
        view.addSubview(contentStackView)
        
        // Adiciona os elementos à StackView, que cuidará do arranjo.
        contentStackView.addArrangedSubview(fireflyImageView)
        contentStackView.addArrangedSubview(logoImageView)
        contentStackView.addArrangedSubview(sloganLabel)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            // Centraliza a StackView na tela
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            // Vagalume ocupa a largura total da StackView
                 fireflyImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
                 
                 // ADICIONE ESTA LINHA: Define a altura do vagalume como 25% da altura da tela
                 fireflyImageView.heightAnchor.constraint(equalTo:
                                                            contentStackView.widthAnchor),


            // Logo ocupa 35% da largura da tela
                   logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
                   
                   // ADICIONE ESTA LINHA: Define a altura do logo como 20% da altura da tela
                   logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

                   // Slogan ocupa largura total da stack
                   sloganLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
               ])
    }

}
