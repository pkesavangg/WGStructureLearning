//
//  HTTPClient.swift
//  ModalViewLearningArc
//
//  Created by Kesavan Panchabakesan on 13/04/25.
//

import Foundation

final class HTTPClient {
    static let shared = HTTPClient()
    private init() {}

    // Generic GET request
    func get<T: Decodable>(_ endpoint: Endpoint, headers: [String: String]? = nil) async throws -> T {
        guard var request = endpoint.urlRequest else {
            throw NetworkError.invalidRequest
        }

        request.httpMethod = "GET"
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return try await send(request: request)
    }

    // Generic POST/PUT/PATCH/DELETE request with a body
    func send<T: Encodable, R: Decodable>(
        _ endpoint: Endpoint,
        method: String,
        body: T,
        headers: [String: String]? = nil
    ) async throws -> R {
        guard var request = endpoint.urlRequest else {
            throw NetworkError.invalidRequest
        }

        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        request.httpBody = try JSONEncoder().encode(body)

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

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}

