//
//  TokenManager.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 03/09/25.
//

import Foundation
import Security

/// Uma classe singleton para gerenciar o token de autenticação JWT de forma segura no Keychain do iOS.
final class TokenManager {
    
    // Cria a instância única (singleton) que será usada em todo o app.
    static let shared = TokenManager()
    
    // Define identificadores únicos para o serviço e a conta no Keychain.
    private let service = "com.seuapp.luminar" // Mude para o bundle ID do seu app
    private let account = "authToken"
    
    // Construtor privado para garantir que ninguém mais possa criar uma instância.
    private init() {}
    
    /// Salva o token de autenticação no Keychain.
    /// - Parameter token: O token JWT recebido do backend.
    func save(token: String) {
        // Converte a string do token para o formato de dados (Data).
        guard let data = token.data(using: .utf8) else { return }
        
        // 1. Query para buscar se já existe um token.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        // 2. Dados a serem atualizados ou adicionados.
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        // 3. Tenta ATUALIZAR um item existente.
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        // 4. Se não encontrou um item para atualizar (errSecItemNotFound), então ADICIONA um novo.
        if status == errSecItemNotFound {
            let addQuery = query.merging([kSecValueData as String: data]) { (_, new) in new }
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }
    
    /// Recupera o token de autenticação do Keychain.
    /// - Returns: O token como uma String, ou `nil` se não for encontrado.
    func retrieve() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            guard let data = dataTypeRef as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    /// Remove o token de autenticação do Keychain (usado para logout).
    func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
