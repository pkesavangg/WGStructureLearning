//
//  Gender.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import Foundation

enum Gender: String, Codable {
    case male
    case female
}

enum WeightUnit: String, Codable {
    case lb
    case kg
}

enum GoalType: String, Codable {
    case gain
    case lose
    case maintain
}

enum ActivityLevel: String, Codable {
    case normal
    case athlete
} 