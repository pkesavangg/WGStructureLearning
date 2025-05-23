//
//  HTTPClient.swift
//  ModalViewLearningArc
//
//  Created by Kesavan Panchabakesan on 13/04/25.
//

import Foundation

@MainActor
final class HTTPClient {
    @Injector var accountService: AccountService
    
    private var accessToken: String {
        accountService.currentUser?.accessToken ?? ""
    }
    
    static let shared = HTTPClient()
    private init() {}
    
    // Generic GET request
    func get<T: Decodable>(
        _ endpoint: Endpoint,
        headers: [String: String]? = nil,
        needsAuth: Bool = false
    ) async throws -> T {
        guard var request = endpoint.urlRequest else {
            throw NetworkError.invalidRequest
        }

        request.httpMethod = "GET"
        var allHeaders = headers ?? [:]
        if needsAuth {
            allHeaders["Authorization"] = "Bearer \(accessToken)"
        }
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return try await send(request: request)
    }

    
    // Generic POST/PUT/PATCH/DELETE request with a body
    func send<T: Encodable, R: Decodable>(
        _ endpoint: Endpoint,
        method: String,
        body: T,
        headers: [String: String]? = nil,
        needsAuth: Bool = false
    ) async throws -> R {
        guard var request = endpoint.urlRequest else {
            throw NetworkError.invalidRequest
        }

        print(accessToken, "Access Token in HTTPClient")
        
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var allHeaders = headers ?? [:]
        if needsAuth && !accessToken.isEmpty {
            allHeaders["Authorization"] = "Bearer \(accessToken)"
        }
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        request.httpBody = try JSONEncoder().encode(body)
        
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")", request.httpBody, allHeaders)
        return try await send(request: request)
    }

    
    // Generic request handler
    private func send<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        // ✅ Handle 204 No Content
        if httpResponse.statusCode == 204 || data.isEmpty {
            // If T is `EmptyResponse`, return it explicitly
            if let emptyResponse = EmptyResponse() as? T {
                return emptyResponse
            } else {
                throw NetworkError.decodingError
            }
        }
        print(httpResponse.statusCode, "HTTP Response Status Code")
        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")", data)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}

