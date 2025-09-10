//
//  QuestionsViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 02/09/25.
//

import Foundation
import UIKit

final class QuestionsViewController: UIViewController {
    
    // MARK: - Propriedades
    private let viewModel = QuestionsViewModel()
    
    // MARK: - Componentes de UI
    
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
        label.text = "Carregando pergunta..."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar Respostas", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Ciclo de Vida
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindViewModel()
        
        viewModel.startQuiz()
    }
    
    // MARK: - Configuração
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        
        view.addSubview(fireflyImageView)
        
        view.addSubview(speechBubbleView)
        speechBubbleView.addSubview(speechLabel)
        
        view.addSubview(answersStackView)
        view.addSubview(submitButton)
        
        submitButton.addSubview(activityIndicator)
        
        // Cria os 5 botões de resposta
        let answers = [
            (title: "Discordo totalmente", value: 1),
            (title: "Discordo", value: 2),
            (title: "Neutro", value: 3),
            (title: "Concordo", value: 4),
            (title: "Concordo totalmente", value: 5)
        ]
        
        for answer in answers {
            let button = createAnswerButton(title: answer.title, value: answer.value)
            answersStackView.addArrangedSubview(button)
        }
        
        // Adiciona a ação ao botão de enviar
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onQuestionChange = { [weak self] newQuestionText in
            self?.speechLabel.text = newQuestionText
        }
        
        viewModel.onQuizFinished = { [weak self] in
            self?.speechLabel.text = "Quiz finalizado!\nClique em Enviar para ver seus resultados."
            self?.answersStackView.isHidden = true
            self?.submitButton.isHidden = false
        }
        
        viewModel.onSubmitResult = { [weak self] result in
            self?.showLoading(false)
            
            if case .failure(let error) = result {
                print("Erro ao enviar: \(error)")
                self?.handleNetworkError(error)
            }
        }
        
        viewModel.onTestSubmissionSuccess = { [weak self] response in
            print("Sucesso! Navegando para a tela de resultados.")
            let resultsVC = ResultsViewController(response:response)
            self?.navigationController?.pushViewController(resultsVC, animated: true)
        }
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
            
            // Botão de Enviar
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            // StackView das Respostas
            answersStackView.topAnchor.constraint(equalTo: speechBubbleView.bottomAnchor, constant: 40),
            answersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // CORREÇÃO DE LAYOUT: Define o limite inferior da stack view em relação ao botão de enviar.
            answersStackView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -40),
            
            // Activity Indicator (centralizado no botão)
            activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor)
        ])
    }
    
    // MARK: - Ações
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        viewModel.answerCurrentQuestion(with: sender.tag)
    }
    
    @objc private func submitButtonTapped() {
        showLoading(true)
        viewModel.submitTest()
    }
    
    // MARK: - Métodos Auxiliares
    
    private func createAnswerButton(title: String, value: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tag = value
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            submitButton.isEnabled = false
            submitButton.setTitle("", for: .disabled)
        } else {
            activityIndicator.stopAnimating()
            submitButton.isEnabled = true
            submitButton.setTitle("Enviar Respostas", for: .normal)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        let message: String
        switch error {
        case .invalidResponse:
            message = "Não foi possível conectar ao servidor. Tente novamente mais tarde."
        case .tokenNotFound:
            message = "Sua sessão expirou. Por favor, faça o login novamente."
        case .requestFailed, .encodingError, .decodingError, .invalidURL:
            message = "Ocorreu um erro inesperado. Por favor, tente novamente."
        }
        showAlert(title: "Erro", message: message)
    }
}
