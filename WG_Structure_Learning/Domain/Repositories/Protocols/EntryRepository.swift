import Foundation

protocol EntryRepository {
    func getEntries() async throws -> [HistoryEntry]
    func saveEntries(_ entries: [HistoryEntry]) throws
    func clearEntries() throws
}
