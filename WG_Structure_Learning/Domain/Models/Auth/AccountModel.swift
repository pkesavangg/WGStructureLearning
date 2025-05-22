import Foundation
import SwiftData

@Model
final class AccountModel {
    // User Data
    @Attribute(.unique) var id: String
    var email: String
    var firstName: String
    var lastName: String
    var gender: String
    var zipcode: String
    var weightUnit: String
    var isWeightlessOn: Bool
    var preferredInputMethod: String?
    var height: Double?
    var activityLevel: String
    var dob: String
    var weightlessBodyFat: Double?
    var weightlessMuscle: Double?
    var weightlessTimestamp: String?
    var weightlessWeight: Double?
    var isStreakOn: Bool
    var dashboardType: String
    var dashboardMetrics: [String]
    var goalType: String?
    var goalWeight: Double?
    var initialWeight: Double?
    var shouldSendEntryNotifications: Bool
    var shouldSendWeightInEntryNotifications: Bool
    var isLogin: Bool
    
    // Auth Data
    var accessToken: String
    var refreshToken: String
    var expiresAt: String
    
    init(from response: Account) {
        self.id = response.account.id
        self.email = response.account.email
        self.firstName = response.account.firstName
        self.lastName = response.account.lastName
        self.gender = response.account.gender.rawValue
        self.zipcode = response.account.zipcode
        self.weightUnit = response.account.weightUnit.rawValue
        self.isWeightlessOn = response.account.isWeightlessOn
        self.preferredInputMethod = response.account.preferredInputMethod
        self.height = response.account.height
        self.activityLevel = response.account.activityLevel.rawValue
        self.dob = response.account.dob
        self.weightlessBodyFat = response.account.weightlessBodyFat
        self.weightlessMuscle = response.account.weightlessMuscle
        self.weightlessTimestamp = response.account.weightlessTimestamp
        self.weightlessWeight = response.account.weightlessWeight
        self.isStreakOn = response.account.isStreakOn
        self.dashboardType = response.account.dashboardType
        self.dashboardMetrics = response.account.dashboardMetrics
        self.goalType = response.account.goalType?.rawValue
        self.goalWeight = response.account.goalWeight
        self.initialWeight = response.account.initialWeight
        self.shouldSendEntryNotifications = response.account.shouldSendEntryNotifications
        self.shouldSendWeightInEntryNotifications = response.account.shouldSendWeightInEntryNotifications
        self.isLogin = false
        
        // Auth data
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        self.expiresAt = response.expiresAt
    }
} 
