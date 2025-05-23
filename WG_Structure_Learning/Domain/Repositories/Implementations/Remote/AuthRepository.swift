//
//  AuthRepository.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//

import Foundation

struct EmptyBody: Codable {}
struct EmptyResponse: Decodable {}

@MainActor
final class AuthRepository {
    private let httpClient = HTTPClient.shared
    
    func login(email: String, password: String) async throws -> Account {
        let loginRequest = LoginRequest(email: email, password: password)
        return try await httpClient.send(
            .login,
            method: "POST",
            body: loginRequest
        )
    }
    
    func createAccount(requestData: SignupRequest) async throws -> Account {
        return try await httpClient.send(
            .signup,
            method: "POST",
            body: requestData
        )
    }
    
    func updateAccount(updateData: SignupRequest) async throws -> Account {
        // Create a JSON-encodable wrapper for the dictionary data
        
        return try await httpClient.send(
            .updateAccount,
            method: "PUT",
            body: updateData,
            needsAuth: true
        )
    }
    
    func logout() async throws -> EmptyResponse {
        try await httpClient.send(
            .logout,
            method: "POST",
            body: EmptyBody(),
            needsAuth: true
        )
    }

    
    func deleteAccount() async throws  -> EmptyResponse {
//        try await httpClient.send(
//            .deleteAccount,
//            method: "DELETE",
//            body: EmptyBody()
//        )
        throw URLError(.badURL)
    }
}
