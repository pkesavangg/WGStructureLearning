import Foundation
import SwiftData

@Model
final class LocalUserModel {
    @Attribute(.unique) var id: String
    var email: String
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
} 