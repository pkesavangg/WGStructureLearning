import Foundation

@MainActor
final class HistoryRepository {
    private let httpClient = HTTPClient.shared
    
    func getEntries(startTimestamp: String? = nil) async throws -> [HistoryEntry] {
        // Use the operationsR4 endpoint to fetch data from /operation/r4
        let response: HistoryResponse = try await httpClient.get(
            .operationsR4(startTimestamp: startTimestamp),
            needsAuth: true
        )
        
        return response.operations
    }
}
