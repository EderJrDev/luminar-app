//
//  DashboardModels.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 10/09/25.
//

import Foundation

struct DashboardResponse: Codable {
    let user: User
    let intelligenceTest: IntelligenceTest
    let areaSuggestions: [AreaSuggestion]
}


struct IntelligenceTest: Codable {
    let testDate: String
    let intelligences: Intelligences

    struct Intelligences: Codable {
        let linguistic: Int
        let logicalMathematical: Int
        let spatial: Int
        let musical: Int
        let bodilyKinesthetic: Int
        let naturalistic: Int
        let interpersonal: Int
        let intrapersonal: Int
        
        var all: [String: Int] {
            return [
                "Linguística": linguistic, "Lógico-Matemática": logicalMathematical, "Espacial": spatial,
                "Musical": musical, "Cinestésico-Corporal": bodilyKinesthetic, "Naturalista": naturalistic,
                "Interpessoal": interpersonal, "Intrapessoal": intrapersonal
            ]
        }
    }
}

struct AreaSuggestion: Codable {
    let area: String
    let sampleProfessions: [String]
    let probability: String
}
