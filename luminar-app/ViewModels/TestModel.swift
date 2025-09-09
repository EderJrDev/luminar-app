//
//  TestModel.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 03/09/25.
//

import Foundation
struct SubmitTestRequest: Codable {
    let respostas: [Int]
}

// O que esperamos receber de volta do backend após o sucesso.
struct Intelligences: Codable {
    let linguistic: Int
    let logicalMathematical: Int
    let spatial: Int
    let musical: Int
    let bodilyKinesthetic: Int
    let naturalistic: Int
    let interpersonal: Int
    let intrapersonal: Int
}

struct SubmitTestResponse: Codable {
    let intelligences: Intelligences
}
