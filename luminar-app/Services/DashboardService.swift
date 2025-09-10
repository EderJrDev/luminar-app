//
//  DashboardService.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 09/09/25.
//

import Foundation

class DashboardService {
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // Função para buscar o perfil do usuário.
    // Ela retorna um Result, que pode ser .success com os dados ou .failure com um erro.
    func fetchUserProfile(completion: @escaping (Result<DashboardResponse, NetworkError>) -> Void) {
        
        
        let urlString = "http://localhost:3001/users/profile"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        guard let token = TokenManager.shared.retrieve() else {
            completion(.failure(.tokenNotFound))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Garante que a resposta seja processada na thread principal para atualizar a UI.
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
                    // Decodifica a resposta JSON para o objeto.
                    let testResponse = try self.jsonDecoder.decode(DashboardResponse.self, from: data)
                    completion(.success(testResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
}
