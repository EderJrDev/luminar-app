//
//  AuthService.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 27/08/25.
//

import Foundation

// Define um erro customizado para a nossa camada de rede.
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(statusCode: Int)
    case encodingError(Error)
    case decodingError(Error)
}

// MARK: - Data Models

// Modelo de dados para o usuário retornado pela API.
struct User: Codable {
    let id: Int
    let fullName: String
    let age: Int
    let gender: String
    let email: String
}

// Modelos para o fluxo de Login
struct UserLoginRequest: Codable {
    let email: String
    let password: String
}

struct UserLoginResponse: Codable {
    let token: String
    let user: User
    let message: String
}


// Classe responsável por toda a comunicação de autenticação com o backend.
class AuthService {
    
    // URL base da sua API.
    private let baseURL = "http://localhost:3001/users"

    // JSON Encoder e Decoder configurados para snake_case
    private var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    /// Tenta registrar um novo usuário no backend.
    /// - Parameters:
    ///   - userData: O objeto `UserRegistrationRequest` com os dados do usuário.
    ///   - completion: Um closure que será chamado com o resultado da operação (`Result<UserRegistrationResponse, NetworkError>`).
    func registerUser(userData: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, NetworkError>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Codifica os dados do usuário para JSON.
            request.httpBody = try jsonEncoder.encode(userData)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        // Cria e executa a tarefa de rede.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Garante que a resposta seja processada na thread principal, pois vai atualizar a UI.
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    completion(.failure(.invalidResponse(statusCode: statusCode)))
                    return
                }
                
                guard let data = data else {
                    // Se não houver dados, ainda podemos ter um código de status para o erro
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    completion(.failure(.invalidResponse(statusCode: statusCode)))
                    return
                }
                
                do {
                    // Decodifica a resposta JSON para o nosso objeto `UserRegistrationResponse`.
                    let userResponse = try self.jsonDecoder.decode(UserRegistrationResponse.self, from: data)
                    completion(.success(userResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
    
    /// Tenta autenticar um usuário no backend.
    /// - Parameters:
    ///   - loginData: O objeto `UserLoginRequest` com os dados de login.
    ///   - completion: Um closure que será chamado com o resultado da operação (`Result<UserLoginResponse, NetworkError>`).
    func loginUser(loginData: UserLoginRequest, completion: @escaping (Result<UserLoginResponse, NetworkError>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Codifica os dados de login para JSON.
            request.httpBody = try jsonEncoder.encode(loginData)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    completion(.failure(.invalidResponse(statusCode: statusCode)))
                    return
                }
                
                guard let data = data else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    completion(.failure(.invalidResponse(statusCode: statusCode)))
                    return
                }
                
                do {
                    // Decodifica a resposta JSON para o nosso objeto `UserLoginResponse`.
                    let loginResponse = try self.jsonDecoder.decode(UserLoginResponse.self, from: data)
                    completion(.success(loginResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
}

