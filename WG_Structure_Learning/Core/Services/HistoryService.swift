import Foundation

@MainActor
@Observable
final class HistoryService {
    static let shared = HistoryService()
    
    private let historyRepository = HistoryRepository()
    private let localRepository = SwiftDataEntryRepository()
    
    var isDataFetching = false
    
    
    
    // Fetch entries from the API and cache them locally
    func fetchAndCacheEntries() async throws -> [HistoryEntry] {
        isDataFetching = true
        
        do {
            // Fetch entries from the API
            let entries = try await historyRepository.getEntries()
            print(entries.count, "entries fetched fetchAndCacheEntries")
            // Cache entries locally
            try localRepository.saveEntries(entries)
            
            isDataFetching = false
            return entries
        } catch {
            print(error.localizedDescription, "entries fetched fetchAndCacheEntries")
            isDataFetching = false
            throw error
        }
    }
    
    // Get entries from local cache
    func getLocalEntries() async throws -> [HistoryEntry] {
        return try await localRepository.getEntries()
    }
    
    // Get entries with fallback to local cache if network fails
    func getEntries() async throws -> [HistoryEntry] {
        do {
            // Try to fetch from API first
            return try await fetchAndCacheEntries()
        } catch {
            print("Failed to fetch entries from API: \(error). Using cached data.")
            // Fall back to local cache if API fails
            return try await localRepository.getEntries()
        }
    }
    
    // Clear local cache
    func clearLocalCache() throws {
        try localRepository.clearEntries()
    }
}
