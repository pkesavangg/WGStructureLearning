//
//  ProfileView.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 23/05/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    
    // State variables to hold editable values
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Date()
    
    // Alert state
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    
                    TextField("Last Name", text: $lastName)
                    
                    DatePicker(
                        "Date of Birth",
                        selection: $dob,
                        displayedComponents: .date
                    )
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(settingsStore.email)
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button(action: saveProfile) {
                        HStack {
                            Spacer()
                            if settingsStore.isUpdatingProfile {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Save Changes")
                            }
                            Spacer()
                        }
                    }
                    .disabled(settingsStore.isUpdatingProfile)
                }
            }
            .navigationTitle("Edit Profile")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Profile Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: loadUserData)
            // Monitor profile update errors
            .onReceive(settingsStore.$profileUpdateError) { error in
                if let error = error {
                    alertMessage = error
                    showAlert = true
                }
            }
        }
    }
    
    private func loadUserData() {
        // Load data from the store
        firstName = settingsStore.firstName
        lastName = settingsStore.lastName
        dob = settingsStore.dob
    }
    
    private func saveProfile() {
        // Validate inputs
        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "First name cannot be empty"
            showAlert = true
            return
        }
        
        guard !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Last name cannot be empty"
            showAlert = true
            return
        }
        
        // Save profile data
        Task {
            await settingsStore.updateUserProfile(
                firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                dob: dob
            )
            
            // Show success message if no error was set
            if settingsStore.profileUpdateError == nil {
                alertMessage = "Profile updated successfully"
                showAlert = true
            }
        }
    }
}
