//
//  UpdateAccountRequest.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 23/05/25.
//

import Foundation

struct UpdateAccountRequest: Codable {
    let firstName: String
    let lastName: String
    let dob: String
    
    // Initialize with the required profile fields
    init(firstName: String, lastName: String, dob: Date) {
        self.firstName = firstName
        self.lastName = lastName
        
        // Format the date to string in ISO8601 format
        let formatter = ISO8601DateFormatter()
        self.dob = formatter.string(from: dob)
    }
}
