import SwiftUI

struct AccountSwitcherView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @Environment(\.dismiss) private var dismiss
    
    // State for loading indicator
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header: Text("Accounts")) {
                        ForEach(settingsStore.getAllAccounts(), id: \.account.id) { account in
                            AccountRow(
                                account: account,
                                isCurrentAccount: settingsStore.isCurrentAccount(accountId: account.account.id),
                                accountStatus: settingsStore.getAccountStatus(for: account.account.id),
                                onSelect: { accountId in
                                    switchToAccount(accountId: accountId)
                                }
                            )
                        }
                        
                        Button(action: {
                            settingsStore.showAddAccountOptions = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Add Account")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                if isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .navigationTitle("Switch Account")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .alert(isPresented: Binding<Bool>(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .actionSheet(isPresented: $settingsStore.showAddAccountOptions) {
                ActionSheet(
                    title: Text("Add Account"),
                    message: Text("Choose an option"),
                    buttons: [
                        .default(Text("Login to Existing Account")) {
                            settingsStore.selectedAccountAction = .login
                            dismiss()
                        },
                        .default(Text("Create New Account")) {
                            settingsStore.selectedAccountAction = .signup
                            dismiss()
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
    
    private func switchToAccount(accountId: String) {
        guard !settingsStore.isCurrentAccount(accountId: accountId) else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                await settingsStore.switchToAccount(accountId: accountId)
                isLoading = false
                dismiss()
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}

// Helper struct for displaying account rows
struct AccountRow: View {
    let account: Account
    let isCurrentAccount: Bool
    let accountStatus: AccountStatus
    let onSelect: (String) -> Void
    
    var body: some View {
        Button(action: {
            onSelect(account.account.id)
        }) {
            HStack {
                // Profile image or initials
                ZStack {
                    Circle()
                        .fill(isCurrentAccount ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    Text(getInitials())
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
                
                VStack(alignment: .leading) {
                    Text("\(account.account.firstName) \(account.account.lastName)")
                        .font(.headline)
                    
                    Text(account.account.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isCurrentAccount {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .disabled(accountStatus == .disabled)
        .opacity(accountStatus == .disabled ? 0.5 : 1.0)
    }
    
    private func getInitials() -> String {
        let firstName = account.account.firstName.prefix(1).uppercased()
        let lastName = account.account.lastName.prefix(1).uppercased()
        return "\(firstName)\(lastName)"
    }
}
