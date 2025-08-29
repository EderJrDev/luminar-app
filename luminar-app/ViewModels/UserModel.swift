//
//  UserModel.swift
//  luminar-app
//
//  Created by Eder Junior Alves Silva on 27/08/25.
//

import Foundation

struct UserRegistrationRequest: Encodable {
    let fullName: String
    let age: Int
    let gender: String
     let email: String
     let password: String
}

struct UserRegistrationResponse: Decodable {
    let id: Int
    let fullName: String
    let age: Int
    let gender: String
    let email: String
    let message: String
}
