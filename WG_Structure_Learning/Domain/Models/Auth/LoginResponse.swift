//
//  LoginResponse.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import Foundation

struct LoginResponse: Codable {
    let account: UserResponse
    let accessToken: String
    let refreshToken: String
    let expiresAt: String
} 