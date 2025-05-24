import Foundation

//struct HistoryResponse: Codable {
//    let operations: [HistoryEntry]
//}
//
//struct HistoryEntry: Codable, Identifiable {
//    let operationType: String
//    let entryTimestamp: String
//    let serverTimestamp: String
//    let weight: Double
//    let bodyFat: Double?
//    let muscleMass: Double?
//    let boneMass: Double?
//    let water: Double?
//    let source: String
//    let bmi: Double?
//    let impedance: Double?
//    let pulse: Double?
//    let unit: String
//    let visceralFatLevel: Double?
//    let subcutaneousFatPercent: Double?
//    let proteinPercent: Double?
//    let skeletalMusclePercent: Double?
//    let bmr: Double?
//    let metabolicAge: Double?
//    
//    // Computed property for id to conform to Identifiable
//    var id: String {
//        // Using entryTimestamp as a unique identifier
//        entryTimestamp
//    }
//    
//    // Computed property for formatted entry date
//    var formattedEntryDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
//        
//        if let date = ISO8601DateFormatter().date(from: entryTimestamp) {
//            return dateFormatter.string(from: date)
//        }
//        return "Unknown date"
//    }
//}
