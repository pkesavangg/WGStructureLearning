import SwiftUI

struct HistoryView: View {
    @State private var store = HistoryStore()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if store.entries.isEmpty && !store.isLoading {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No History Entries")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your weight and body composition history will appear here.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            Task {
                                await store.refresh()
                            }
                        }) {
                            Text("Refresh")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                } else {
                    // List of history entries
                    List {
                        ForEach(store.entries) { entry in
                            HistoryEntryRow(entry: entry, store: store)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        isRefreshing = true
                        await store.refresh()
                        isRefreshing = false
                    }
                }
                
                // Loading overlay
                if store.isLoading && !isRefreshing {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            
                            Text("Loading entries...")
                                .foregroundColor(.white)
                                .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await store.refresh()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(store.isLoading)
                }
            }
        }
        .task {
            // Fetch entries when the view appears
            if store.entries.isEmpty {
                await store.fetchEntries()
            }
        }
        .alert("Error", isPresented: .init(
            get: { store.errorMessage != nil },
            set: { if !$0 { store.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = store.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    let store: HistoryStore
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main row content
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.formattedEntryDate)
                        .font(.headline)
                    
                    Text(store.formatWeight(entry.weight ?? 0.0, unit: entry.unit ?? "lb"))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Operation type badge
                Text(entry.operationType.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        entry.operationType == "add" ? Color.green.opacity(0.2) :
                        entry.operationType == "delete" ? Color.red.opacity(0.2) :
                        Color.blue.opacity(0.2)
                    )
                    .foregroundColor(
                        entry.operationType == "add" ? .green :
                        entry.operationType == "delete" ? .red :
                        .blue
                    )
                    .cornerRadius(4)
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            
            // Expanded details
            if isExpanded {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    // Body metrics section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Body Metrics")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            MetricView(label: "BMI", value: entry.bmi?.description ?? "N/A")
                            MetricView(label: "Body Fat", value: store.formatPercentage(entry.bodyFat))
                            MetricView(label: "Muscle Mass", value: entry.muscleMass?.description ?? "N/A")
                            MetricView(label: "Water", value: store.formatPercentage(entry.water))
                            MetricView(label: "Bone Mass", value: entry.boneMass?.description ?? "N/A")
                            MetricView(label: "Visceral Fat", value: entry.visceralFatLevel?.description ?? "N/A")
                        }
                    }
                    
                    // Additional metrics section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Additional Metrics")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            MetricView(label: "Subcutaneous Fat", value: store.formatPercentage(entry.subcutaneousFatPercent))
                            MetricView(label: "Protein", value: store.formatPercentage(entry.proteinPercent))
                            MetricView(label: "Skeletal Muscle", value: store.formatPercentage(entry.skeletalMusclePercent))
                            MetricView(label: "BMR", value: entry.bmr?.description ?? "N/A")
                            MetricView(label: "Metabolic Age", value: entry.metabolicAge?.description ?? "N/A")
                            MetricView(label: "Source", value: entry.source.capitalized)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

struct MetricView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label + ":")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    HistoryView()
}
