import Foundation
import SwiftUI
//
//{"operationType":"create","entryTimestamp":"2025-02-26T07:08:23.000Z","serverTimestamp":"2025-02-26T07:08:33.150Z","weight":196,"bodyFat":null,"muscleMass":null,"boneMass":null,"water":null,"source":"btWifiR4","bmi":33,"impedance":null,"pulse":null,"unit":"kg","visceralFatLevel":null,"subcutaneousFatPercent":null,"proteinPercent":null,"skeletalMusclePercent":null,"bmr":null,"metabolicAge":null}

// Define the history entry model directly in the store for simplicity
struct HistoryEntry: Identifiable, Codable {
    let operationType: String
    let entryTimestamp: String
    let serverTimestamp: String
    let weight: Double?
    let bodyFat: Double?
    let muscleMass: Double?
    let boneMass: Double?
    let water: Double?
    let source: String
    let bmi: Double?
    let impedance: Double?
    let pulse: Double?
    let unit: String
    let visceralFatLevel: Double?
    let subcutaneousFatPercent: Double?
    let proteinPercent: Double?
    let skeletalMusclePercent: Double?
    let bmr: Double?
    let metabolicAge: Double?
    
    // Computed property for id to conform to Identifiable
    var id: String {
        // Using entryTimestamp as a unique identifier
        entryTimestamp
    }
    
    // Computed property for formatted entry date
    var formattedEntryDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        if let date = ISO8601DateFormatter().date(from: entryTimestamp) {
            return dateFormatter.string(from: date)
        }
        return "Unknown date"
    }
}

//// Response structure for the API
struct HistoryResponse: Codable {
    let operations: [HistoryEntry]
}

@MainActor
@Observable
class HistoryStore {
    @ObservationIgnored
    @Injector private var historyService: HistoryService
    // State variables
    var entries: [HistoryEntry] = []
    var isLoading = false
    var errorMessage: String? = nil
    var lastRefresh: Date? = nil
    
    // Mock data for initial development
    private let mockEntries: [HistoryEntry] = [
        HistoryEntry(
            operationType: "delete",
            entryTimestamp: "2024-09-30T04:46:53.740Z",
            serverTimestamp: "2025-04-21T05:04:59.613Z",
            weight: 500,
            bodyFat: nil,
            muscleMass: nil,
            boneMass: nil,
            water: nil,
            source: "manual",
            bmi: nil,
            impedance: nil,
            pulse: nil,
            unit: "lb",
            visceralFatLevel: nil,
            subcutaneousFatPercent: nil,
            proteinPercent: nil,
            skeletalMusclePercent: nil,
            bmr: nil,
            metabolicAge: nil
        ),
        HistoryEntry(
            operationType: "add",
            entryTimestamp: "2024-09-29T08:30:00.000Z",
            serverTimestamp: "2025-04-20T08:45:12.123Z",
            weight: 185.5,
            bodyFat: 22.3,
            muscleMass: 140.2,
            boneMass: 7.8,
            water: 55.4,
            source: "scale",
            bmi: 24.6,
            impedance: 500,
            pulse: 72,
            unit: "lb",
            visceralFatLevel: 8,
            subcutaneousFatPercent: 18.5,
            proteinPercent: 16.2,
            skeletalMusclePercent: 45.3,
            bmr: 1850,
            metabolicAge: 32
        ),
        HistoryEntry(
            operationType: "add",
            entryTimestamp: "2024-09-28T07:15:00.000Z",
            serverTimestamp: "2025-04-19T07:20:45.789Z",
            weight: 186.2,
            bodyFat: 22.5,
            muscleMass: 139.8,
            boneMass: 7.8,
            water: 55.1,
            source: "scale",
            bmi: 24.7,
            impedance: 510,
            pulse: 74,
            unit: "lb",
            visceralFatLevel: 8,
            subcutaneousFatPercent: 18.7,
            proteinPercent: 16.0,
            skeletalMusclePercent: 45.1,
            bmr: 1845,
            metabolicAge: 32
        )
    ]
    
    init() {
        Task {
            do {
                self.entries = try await historyService.fetchAndCacheEntries()
            } catch {
                print("Error fetching and caching history entries: \(error)")
            }
        }
        self.lastRefresh = Date()
    }
    
    // Function to fetch history entries from the API
    func fetchEntries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // In a real implementation, this would make an API call
            // For now, we'll just use the mock data with a delay to simulate network latency
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            // Update with mock data
            self.entries = mockEntries
            self.lastRefresh = Date()
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to fetch history entries: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    // Function to refresh the data
    func refresh() async {
        await fetchEntries()
    }
    
    // Function to format weight with appropriate unit
    func formatWeight(_ weight: Double, unit: String) -> String {
        return "\(String(format: "%.1f", weight)) \(unit)"
    }
    
    // Function to format percentage values
    func formatPercentage(_ value: Double?) -> String {
        guard let value = value else { return "N/A" }
        return "\(String(format: "%.1f", value))%"
    }
}
