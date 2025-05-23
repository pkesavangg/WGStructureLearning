//
//  UserResponse.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 19/05/25.
//


import Foundation

struct UserResponse: Codable {
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var gender: Gender
    var zipcode: String
    var weightUnit: WeightUnit
    var isWeightlessOn: Bool
    var preferredInputMethod: String?
    var height: Double?
    var activityLevel: ActivityLevel
    var dob: String
    var weightlessBodyFat: Double?
    var weightlessMuscle: Double?
    var weightlessTimestamp: String?
    var weightlessWeight: Double?
    var isStreakOn: Bool
    var dashboardType: String
    var dashboardMetrics: [String]
    var goalType: GoalType?
    var goalWeight: Double?
    var initialWeight: Double?
    var shouldSendEntryNotifications: Bool
    var shouldSendWeightInEntryNotifications: Bool
}
