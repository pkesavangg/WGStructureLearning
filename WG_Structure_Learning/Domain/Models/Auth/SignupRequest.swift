//
//  SignupRequest.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import Foundation

struct SignupRequest: Codable {
    let email: String
    let password: String?
    let firstName: String
    let lastName: String       // will be a space if blank
    let gender: String
    let zipcode: String        // will be a space if blank
    let dob: String            // formatted "YYYY-MM-DD"
    let height: Double            // in the expected unit (likely cm or inches)
    let device: String?        // optional device field
}
