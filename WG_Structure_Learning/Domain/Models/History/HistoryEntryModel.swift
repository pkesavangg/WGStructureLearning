import Foundation
import SwiftData

@Model
final class HistoryEntryModel {
    var id: String
    var operationType: String
    var entryTimestamp: String
    var serverTimestamp: String
    var weight: Double
    var bodyFat: Double?
    var muscleMass: Double?
    var boneMass: Double?
    var water: Double?
    var source: String
    var bmi: Double?
    var impedance: Double?
    var pulse: Double?
    var unit: String
    var visceralFatLevel: Double?
    var subcutaneousFatPercent: Double?
    var proteinPercent: Double?
    var skeletalMusclePercent: Double?
    var bmr: Double?
    var metabolicAge: Double?
    
    init(from entry: HistoryEntry) {
        self.id = entry.id
        self.operationType = entry.operationType
        self.entryTimestamp = entry.entryTimestamp
        self.serverTimestamp = entry.serverTimestamp
        self.weight = entry.weight ?? 0.0
        self.bodyFat = entry.bodyFat
        self.muscleMass = entry.muscleMass
        self.boneMass = entry.boneMass
        self.water = entry.water
        self.source = entry.source
        self.bmi = entry.bmi
        self.impedance = entry.impedance
        self.pulse = entry.pulse
        self.unit = entry.unit ?? "lb" // Default to "lbs" if unit is nil
        self.visceralFatLevel = entry.visceralFatLevel
        self.subcutaneousFatPercent = entry.subcutaneousFatPercent
        self.proteinPercent = entry.proteinPercent
        self.skeletalMusclePercent = entry.skeletalMusclePercent
        self.bmr = entry.bmr
        self.metabolicAge = entry.metabolicAge
    }
    
    func toHistoryEntry() -> HistoryEntry {
        return HistoryEntry(
            operationType: operationType,
            entryTimestamp: entryTimestamp,
            serverTimestamp: serverTimestamp,
            weight: weight,
            bodyFat: bodyFat,
            muscleMass: muscleMass,
            boneMass: boneMass,
            water: water,
            source: source,
            bmi: bmi,
            impedance: impedance,
            pulse: pulse,
            unit: unit,
            visceralFatLevel: visceralFatLevel,
            subcutaneousFatPercent: subcutaneousFatPercent,
            proteinPercent: proteinPercent,
            skeletalMusclePercent: skeletalMusclePercent,
            bmr: bmr,
            metabolicAge: metabolicAge
        )
    }
}

extension Array where Element == HistoryEntryModel {
    func toHistoryEntries() -> [HistoryEntry] {
        return self.map { $0.toHistoryEntry() }
    }
}
