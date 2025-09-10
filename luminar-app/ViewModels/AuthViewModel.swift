//
//  AuthViewModel.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 27/08/25.
//

import Foundation

class AuthViewModel {

    // MARK: - Dependencies
    private let authService: AuthService

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    // MARK: - State
    private enum AuthMode {
        case signIn
        case signUp
    }
    private var currentMode: AuthMode = .signIn {
        didSet {
            onStateChange?()
        }
    }
    
    // NOVO: Estado para controlar o feedback de carregamento na UI.
    private var isLoading = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }

    // MARK: - Bindings (Comunicação com a View)
    var onStateChange: (() -> Void)?
    var onRegistrationSuccess: ((UserRegistrationResponse) -> Void)?
    var onLoginSuccess: ((UserLoginResponse) -> Void)?
    var onRegistrationFailure: ((String) -> Void)?
    var onLoginFailure: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    // MARK: - Input Data
    var fullName = ""
    var age = ""
    var email = ""
    var password = ""

    // MARK: - Presentation Logic
    var actionButtonTitle: String {
        return currentMode == .signIn ? "Entrar" : "Cadastrar"
    }
    var isEmailFieldHidden: Bool {
        return currentMode == .signUp
    }
    var isNameFieldHidden: Bool {
        return currentMode == .signIn
    }
    var isAgeFieldHidden: Bool {
        return currentMode == .signIn
    }
    var isSignInModeActive: Bool {
        return currentMode == .signIn
    }

    // MARK: - User Actions
    func didTapSignIn() {
        guard currentMode != .signIn else { return }
        currentMode = .signIn
    }
    func didTapSignUp() {
        guard currentMode != .signUp else { return }
        currentMode = .signUp
    }
    
    func performMainAction() {
        // LOG: Verificando se a ação principal foi chamada.
        print("AuthViewModel: performMainAction() foi chamado no modo \(currentMode).")
        
        switch currentMode {
        case .signIn:
            performLogin()
        case .signUp:
            performRegistration()
        }
    }
    
    private func performRegistration() {
        // LOG: Verificando se o cadastro foi iniciado.
        print("AuthViewModel: performRegistration() foi chamado.")
        
        guard !isLoading else {
            print("AuthViewModel: Bloqueando cadastro, requisição já em andamento.")
            return
        }
        
        guard !fullName.isEmpty, let ageInt = Int(age) else {
            // LOG: Erro de validação.
            print("AuthViewModel: Erro de validação - Nome ou idade faltando.")
            onRegistrationFailure?("Nome e idade são obrigatórios.")
            return
        }
        
        // NOVO: Inicia o estado de carregamento.
        isLoading = true
        
        let registrationData = UserRegistrationRequest(
            fullName: fullName,
            age: ageInt,
            gender: "Masculino",
            email: email,
            password: password
        )
        
        // LOG: Dados que serão enviados para a API.
        print("AuthViewModel: Enviando dados para o serviço: \(registrationData)")
        
        authService.registerUser(userData: registrationData) { [weak self] result in
            // NOVO: Finaliza o estado de carregamento, não importa o resultado.
            self?.isLoading = false
            
            switch result {
            case .success(let response):
                // LOG: Sucesso na chamada da API.
                print("AuthViewModel: Registro bem-sucedido - \(response)")
                self?.onRegistrationSuccess?(response)
            case .failure(let error):
                // LOG: Falha na chamada da API.
                print("AuthViewModel: Falha no registro - \(error)")
                var errorMessage = "Ocorreu um erro. Tente novamente."
                if case .invalidResponse = error {
                    errorMessage = "Não foi possível conectar ao servidor."
                }
                self?.onRegistrationFailure?(errorMessage)
            }
        }
        
    }
    
    private func performLogin() {
        // LOG: Verificando se o cadastro foi iniciado.
        print("AuthViewModel: performLogin() foi chamado.")
        
        guard !isLoading else {
            print("AuthViewModel: Bloqueando cadastro, requisição já em andamento.")
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            // Erro de validação.
            print("AuthViewModel: Erro de validação - Email ou senha faltando.")
            onRegistrationFailure?("Email e senha são obrigatórios.")
            return
        }
        
        // Inicia o estado de carregamento.
        isLoading = true
        
        let loginData = UserLoginRequest(
            email: email, password: password
        )
        
        // Dados que serão enviados para a API.
        print("AuthViewModel: Enviando dados para o serviço: \(loginData)")
        
        authService.loginUser(loginData: loginData) { [weak self] result in
            // Finaliza o estado de carregamento, não importa o resultado.
            self?.isLoading = false
            
            switch result {
            case .success(let response):
                // Sucesso na chamada da API.
                print("AuthViewModel: Login bem-sucedido - \(response)")
                TokenManager.shared.save(token: response.token)
                self?.onLoginSuccess?(response)
            case .failure(let error):
                // Falha na chamada da API.
                print("AuthViewModel: Falha no login - \(error)")
                var errorMessage = "Ocorreu um erro. Tente novamente."
                if case .invalidResponse = error {
                    errorMessage = "Não foi possível conectar ao servidor."
                }
                self?.onLoginFailure?(errorMessage)
            }
        }
        
    }
}
