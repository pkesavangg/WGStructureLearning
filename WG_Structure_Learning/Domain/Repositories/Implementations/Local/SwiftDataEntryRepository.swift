import Foundation
import SwiftData

@MainActor
final class SwiftDataEntryRepository: EntryRepository {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() {
        do {
            // Create an in-memory container for history entries to avoid conflicts
            let schema = Schema([HistoryEntryModel.self])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true) // Use in-memory storage
            self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            self.modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }
    
    func getEntries() async throws -> [HistoryEntry] {
        let descriptor = FetchDescriptor<HistoryEntryModel>(sortBy: [SortDescriptor(\.entryTimestamp, order: .reverse)])
        let entries = try modelContext.fetch(descriptor)
        return entries.toHistoryEntries()
    }
    
    func saveEntries(_ entries: [HistoryEntry]) throws {
        // First, clear existing entries to avoid duplicates
        try clearEntries()
        
        // Then save the new entries
        for entry in entries {
            let entryModel = HistoryEntryModel(from: entry)
            modelContext.insert(entryModel)
        }
        
        try modelContext.save()
    }
    
    func clearEntries() throws {
        let descriptor = FetchDescriptor<HistoryEntryModel>()
        let entries = try modelContext.fetch(descriptor)
        
        for entry in entries {
            modelContext.delete(entry)
        }
        
        try modelContext.save()
    }
}
