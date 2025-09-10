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

struct Descriptions: Codable {
    let linguistic: String
    let logicalMathematical: String
    let spatial: String
    let musical: String
    let bodilyKinesthetic: String
    let naturalistic: String
    let interpersonal: String
    let intrapersonal: String
}

struct SubmitTestResponse: Codable {
    let intelligences: Intelligences
    let descriptions: Descriptions
}
