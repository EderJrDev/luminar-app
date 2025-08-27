//
//  AuthViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 26/08/25.
//

import UIKit

// ViewController para a tela de autenticação (Entrar/Cadastrar).
class AuthViewController: UIViewController {

    // MARK: - State
    
    // Enum para controlar o modo da tela (Entrar ou Cadastrar).
    private enum AuthMode {
        case signIn
        case signUp
    }
    
    // Mantém o estado atual da tela. Começa em 'signIn'.
    private var currentMode: AuthMode = .signIn {
        didSet {
            updateUIForCurrentMode()
        }
    }

    // MARK: - UI Components

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background-blue")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let fireflyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firefly")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let formContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Botão "Entre"
    private lazy var signInButton: UIButton = {
        let button = createAuthSwitchButton(title: "Entre")
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return button
    }()

    // Botão "Cadastre"
    private lazy var signUpButton: UIButton = {
        let button = createAuthSwitchButton(title: "Cadastre")
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        return button
    }()
    
    // StackView para os botões de troca de modo.
    private lazy var authSwitchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signInButton, signUpButton, UIView()]) // UIView no final para empurrar os botões
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Campo de texto para o nome.
    private let nameTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "NOME")
        textField.autocapitalizationType = .words
        return textField
    }()
    
    // Campo de texto para o email (inicialmente oculto).
    private let emailTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "EMAIL")
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.isHidden = true // Começa oculto
        return textField
    }()

    // Campo de texto para a senha.
    private let passwordTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "SENHA")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // StackView para organizar os campos de texto.
    private lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Botão principal de ação ("Entrar" ou "Cadastrar").
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.appBlue
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        // Adicionar ação aqui se necessário, ex: button.addTarget(...)
        return button
    }()
    
    // StackView para os botões de login social.
    private lazy var socialButtonsStackView: UIStackView = {
        let appleButton = createSocialLoginButton(imageName: "apple-logo")
        let googleButton = createSocialLoginButton(imageName: "google-logo")
        let facebookButton = createSocialLoginButton(imageName: "facebook-logo")
        
        let stackView = UIStackView(arrangedSubviews: [appleButton, googleButton, facebookButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        updateUIForCurrentMode() // Configura a UI inicial para o modo .signIn
        
        // Adiciona um gesto para dispensar o teclado ao tocar fora dos campos
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(fireflyImageView)
        view.addSubview(formContainerView)
        
        formContainerView.addSubview(authSwitchStackView)
        formContainerView.addSubview(fieldsStackView)
        formContainerView.addSubview(actionButton)
        formContainerView.addSubview(socialButtonsStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            fireflyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fireflyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fireflyImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            fireflyImageView.heightAnchor.constraint(equalTo: fireflyImageView.widthAnchor),

            formContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            formContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            authSwitchStackView.topAnchor.constraint(equalTo: formContainerView.topAnchor, constant: 30),
            authSwitchStackView.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 40),
            authSwitchStackView.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -40),
            authSwitchStackView.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.widthAnchor.constraint(equalToConstant: 160),
            
            signUpButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),

            
            fieldsStackView.topAnchor.constraint(equalTo: authSwitchStackView.bottomAnchor, constant: 30),
            fieldsStackView.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 40),
            fieldsStackView.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -40),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 56),
            
            actionButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 30),
            actionButton.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            actionButton.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor, multiplier: 0.8),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            socialButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            socialButtonsStackView.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            socialButtonsStackView.widthAnchor.constraint(equalTo: formContainerView.widthAnchor, multiplier: 0.6),
            socialButtonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - UI Update Logic
    
    /// Atualiza a interface com base no modo atual (signIn ou signUp).
    private func updateUIForCurrentMode() {
        // Anima a transição para suavidade
        UIView.animate(withDuration: 0.3) {
            switch self.currentMode {
            case .signIn:
                // Atualiza aparência dos botões de troca
                self.signInButton.backgroundColor = UIColor.appBlue
                self.signInButton.setTitleColor(.white, for: .normal)
                
                self.signUpButton.backgroundColor = .clear
                self.signUpButton.setTitleColor(UIColor.appBlue, for: .normal)
                
                // Oculta o campo de email
                self.emailTextField.isHidden = true
                
                // Atualiza o botão de ação principal
                self.actionButton.setTitle("Entrar", for: .normal)
                
            case .signUp:
                // Atualiza aparência dos botões de troca
                self.signUpButton.backgroundColor = UIColor.appBlue
                self.signUpButton.setTitleColor(.white, for: .normal)
                
                self.signInButton.backgroundColor = .clear
                self.signInButton.setTitleColor(UIColor.appBlue, for: .normal)
                
                // Mostra o campo de email
                self.emailTextField.isHidden = false
                
                // Atualiza o botão de ação principal
                self.actionButton.setTitle("Cadastrar", for: .normal)
            }
            // Força o layout a se atualizar dentro da animação
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapSignIn() {
        currentMode = .signIn
    }
    
    @objc private func didTapSignUp() {
        currentMode = .signUp
    }
    
    // MARK: - Helper Methods
    
    /// Cria e configura um botão de troca de modo (Entre/Cadastre).
    private func createAuthSwitchButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    /// Cria e configura um campo de texto padronizado.
    private static func createStyledTextField(placeholder: String) -> UITextField {
        let textField = PaddedTextField() // Usando a subclasse com padding
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.appYellowBackground
        textField.layer.cornerRadius = 28
        textField.font = .systemFont(ofSize: 18, weight: .bold)
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        
        // Atribui cor e fonte ao placeholder
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appYellowText,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    /// Cria e configura um botão de login social.
    private func createSocialLoginButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

// MARK: - Custom UITextField for Padding

/// Uma subclasse de UITextField que adiciona padding horizontal.
class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


// MARK: - UIColor Extension

// É uma boa prática organizar as cores do app em uma extensão.
extension UIColor {
    static let appBlue = UIColor(red: 0.13, green: 0.16, blue: 0.78, alpha: 1.00)
    static let appYellowBackground = UIColor(red: 1.00, green: 0.98, blue: 0.90, alpha: 1.00)
    static let appYellowText = UIColor(red: 0.82, green: 0.78, blue: 0.55, alpha: 1.00)
}
