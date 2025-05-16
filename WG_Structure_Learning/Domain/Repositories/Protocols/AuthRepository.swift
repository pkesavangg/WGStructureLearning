import Foundation

protocol AuthRepository {
    func signIn(email: String, password: String) async throws -> Bool
    func signOut() async throws
    func getCurrentUser() async throws -> User?
}
