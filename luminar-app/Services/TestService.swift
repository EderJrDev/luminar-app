//
//  TestService.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 03/09/25.
//

import Foundation

class TestService {
    
    // URL base da sua API. Lembre-se de trocar para a URL real.
    private let baseURL = URL(string: "http://localhost:3001")
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // Função que recebe os dados do teste e tenta enviá-los.
    // O @escaping é necessário porque a chamada de rede é assíncrona.
    func submitTest(payload: SubmitTestRequest, completion: @escaping (Result<SubmitTestResponse, NetworkError>) -> Void) {
        
        // 1. Monta a URL completa do endpoint
        guard let url = baseURL?.appendingPathComponent("/users/test") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let token = TokenManager.shared.retrieve() else {
            // Se o token não for encontrado, a requisição não pode ser feita.
            completion(.failure(.tokenNotFound))
            return
        }
        
        // 2. Cria a requisição (Request) e define como POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // 3. Converte o objeto 'payload' em dados JSON
        do {
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.requestFailed(error)))
            return
        }
        
        // 4. Executa a tarefa de rede
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Garante que a resposta volte para a thread principal para atualizar a UI
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
                    // Decodifica a resposta JSON para o nosso objeto.
                    let testResponse = try self.jsonDecoder.decode(SubmitTestResponse.self, from: data)
                    completion(.success(testResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume() // Inicia a requisição
    }
}
