//
//  UserResponse.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import Foundation

struct UserResponse: Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: Gender
    let zipcode: String
    let weightUnit: WeightUnit
    let isWeightlessOn: Bool
    let preferredInputMethod: String?
    let height: Double?
    let activityLevel: ActivityLevel
    let dob: String
    let weightlessBodyFat: Double?
    let weightlessMuscle: Double?
    let weightlessTimestamp: String?
    let weightlessWeight: Double?
    let isStreakOn: Bool
    let dashboardType: String
    let dashboardMetrics: [String]
    let goalType: GoalType?
    let goalWeight: Double?
    let initialWeight: Double?
    let shouldSendEntryNotifications: Bool
    let shouldSendWeightInEntryNotifications: Bool
} 