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
//    private let logoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "luminar-logo")
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()

    // Texto do slogan.
    private let sloganLabel: UILabel = {
        let label = UILabel()
        label.text = "Venha com o Lume descobrir o seu brilho"
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // StackView para organizar os elementos verticalmente.
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupTapGesture() // Adiciona a configuração do gesto de toque.
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(fireflyImageView)
//        contentStackView.addArrangedSubview(logoImageView)
        contentStackView.addArrangedSubview(sloganLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.2),

            fireflyImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            fireflyImageView.heightAnchor.constraint(equalTo: contentStackView.widthAnchor),

//            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
//            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            sloganLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
        ])
    }
    
    // MARK: - Actions & Navigation
    
    /// Configura o reconhecimento de gesto de toque na tela.
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// É chamado quando o usuário toca na tela.
    @objc private func didTapScreen() {
        // Cria a instância da nova tela.
        let authVC = AuthViewController()
        
        // Define o estilo de apresentação (tela cheia).
        authVC.modalPresentationStyle = .fullScreen
        
        // Apresenta a nova tela.
        present(authVC, animated: true, completion: nil)
    }
}
