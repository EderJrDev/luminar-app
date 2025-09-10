//
//  DashboardViewModel.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 09/09/25.
//

import Foundation

class DashboardViewModel {
    
    // Enum para controlar os diferentes estados da tela.
    enum ViewState {
        case loading
        case success(DashboardResponse)
        case error(String)
    }
    
    // MARK: - Properties
    
    private let dashboardService: DashboardService
    
    // Closures que a ViewController vai "escutar" para saber quando atualizar a UI.
    var onStateChange: ((ViewState) -> Void)?
    var onLogout: (() -> Void)?
    
    // MARK: - Initializer
    
    init(dashboardService: DashboardService = DashboardService()) {
        self.dashboardService = dashboardService
    }
    
    // MARK: - Public Methods
    
    func loadUserProfile() {
        // Informa a View que estamos carregando os dados.
        onStateChange?(.loading)
        
        // Chama o serviço para buscar os dados.
        dashboardService.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let profileData):
                // Em caso de sucesso, informa a View e envia os dados.
                self?.onStateChange?(.success(profileData))
            case .failure(let error):
                // Em caso de erro, informa a View com uma mensagem.
                self?.onStateChange?(.error("Não foi possível carregar seu perfil. Tente novamente."))
                print("Erro ao carregar perfil: \(error)")
            }
        }
    }
    
    func handleLogout() {
        // Lógica de logout:
        // - Limpar tokens salvos (UserDefaults, Keychain, etc.)
        // - Limpar dados de sessão
        
        print("Usuário deslogado.")
        // Avisa a ViewController para realizar a navegação para a tela de Login.
        onLogout?()
    }
}
