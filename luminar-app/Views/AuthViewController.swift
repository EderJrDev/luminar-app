//
//  AuthViewController.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 26/08/25.
//

import UIKit

// ViewController para a tela de autenticação (Entrar/Cadastrar).
class AuthViewController: UIViewController {
    
    private let viewModel = AuthViewModel()

    // MARK: - UI Components
    
    private let activityIndicator: UIActivityIndicatorView = {
          let indicator = UIActivityIndicatorView(style: .medium)
          indicator.color = .white
          indicator.hidesWhenStopped = true
          indicator.translatesAutoresizingMaskIntoConstraints = false
          return indicator
      }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background-blue")
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
        let textField = createStyledTextField(placeholder: "Nome")
        textField.autocapitalizationType = .words
        textField.isHidden = true
        return textField
    }()
    
    // Campo de texto para o email (inicialmente oculto).
    private let emailTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "Email")
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let ageTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "Idade")
        textField.keyboardType = .numberPad
        textField.autocapitalizationType = .none
        textField.isHidden = true // Começa oculto
        return textField
    }()

    // Campo de texto para a senha.
    private let passwordTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "Senha")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // StackView para organizar os campos de texto.
    private lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, ageTextField, passwordTextField])
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
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside) // chama a funcao de cadastro
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBindings()
        updateUI()
        
        // Adiciona um gesto para dispensar o teclado ao tocar fora dos campos
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(fireflyImageView)
        view.addSubview(formContainerView)
        
        formContainerView.addSubview(authSwitchStackView)
        formContainerView.addSubview(fieldsStackView)
        formContainerView.addSubview(actionButton)
    }
    
    /// Conecta a ViewController ao ViewModel.
     private func setupBindings() {
         // A ViewController "assina" as mudanças do ViewModel.
         // Toda vez que `onStateChange` for chamado no ViewModel, o código neste closure será executado.
         viewModel.onStateChange = { [weak self] in
             // Usamos [weak self] para evitar ciclos de retenção de memória.
             self?.updateUI()
         }
         
         viewModel.onRegistrationSuccess = { [weak self] response in
                    print("Sucesso! Mensagem: \(response.message)")
                    self?.showAlert(title: "Sucesso!", message: response.message) {
                        let homeVC = HomeViewController()
                           let nav = UINavigationController(rootViewController: homeVC)

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
                
                viewModel.onRegistrationFailure = { [weak self] errorMessage in
                    print("Erro: \(errorMessage)")
                    self?.showAlert(title: "Erro", message: errorMessage)
                }
                
              
         viewModel.onLoginSuccess = { [weak self] response in
                    print("Sucesso! Mensagem: \(response.message)")
//                    self?.showAlert(title: "Sucesso!", message: response.message) {
                        let homeVC = HomeViewController()
                           let nav = UINavigationController(rootViewController: homeVC)

                           if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let window = windowScene.windows.first {
                               UIView.transition(with: window,
                                                 duration: 0.4,
                                                 options: .transitionCrossDissolve,
                                                 animations: {
                                   window.rootViewController = nav
                               })
                           }
//                    }
                }
         
         viewModel.onLoginFailure = { [weak self] errorMessage in
             print("Erro: \(errorMessage)")
             self?.showAlert(title: "Erro", message: errorMessage)
         }
         
         viewModel.onLoadingStateChange = { [weak self] isLoading in
             self?.handleLoadingState(isLoading)
         }
         
     }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            fireflyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fireflyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fireflyImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
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
            
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            
            actionButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 30),
            actionButton.centerXAnchor.constraint(equalTo: formContainerView.centerXAnchor),
            actionButton.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor, multiplier: 0.8),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - UI Update Logic
      
      private func updateUI() {
          UIView.animate(withDuration: 0.3) {
              // Pega os valores diretamente do ViewModel
              self.actionButton.setTitle(self.viewModel.actionButtonTitle, for: .normal)
              self.nameTextField.isHidden = self.viewModel.isNameFieldHidden
              self.ageTextField.isHidden = self.viewModel.isAgeFieldHidden
              
              // Atualiza a aparência dos botões de troca
              if self.viewModel.isSignInModeActive {
                  self.signInButton.backgroundColor = UIColor.appBlue
                  self.signInButton.setTitleColor(.white, for: .normal)
                  self.signUpButton.backgroundColor = .clear
                  self.signUpButton.setTitleColor(UIColor.appBlue, for: .normal)
              } else {
                  self.signUpButton.backgroundColor = UIColor.appBlue
                  self.signUpButton.setTitleColor(.white, for: .normal)
                  self.signInButton.backgroundColor = .clear
                  self.signInButton.setTitleColor(UIColor.appBlue, for: .normal)
              }
              
              self.view.layoutIfNeeded()
          }
      }
    
    // Função para gerenciar o estado de carregamento da UI.
    private func handleLoadingState(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            actionButton.isEnabled = false
            // Esconde o título do botão para mostrar apenas o indicador.
            actionButton.setTitle("...", for: .disabled)
        } else {
            activityIndicator.stopAnimating()
            actionButton.isEnabled = true
            // Restaura o título do botão.
            actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        }
    }
    
    
    // MARK: - Actions
    
    // As ações agora apenas notificam o ViewModel. Elas não mudam o estado diretamente.
    @objc private func didTapSignIn() {
        viewModel.didTapSignIn()
    }
    
    @objc private func didTapSignUp() {
        viewModel.didTapSignUp()
    }
    
    @objc private func didTapActionButton() {
          // Confirma que o toque no botão está sendo registrado.
          print("AuthViewController: didTapActionButton() foi chamado.")
          viewModel.performMainAction()
      }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.fullName = textField.text ?? ""
        case ageTextField:
            viewModel.age = textField.text ?? ""
        case emailTextField:
            viewModel.email = textField.text ?? ""
        case passwordTextField:
            viewModel.password = textField.text ?? ""
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               completion?()
           }))
           present(alertController, animated: true)
       }
    
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
        let textField = PaddedTextField()
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
