import SwiftUI
/*
 @MainActor ensures:

 All properties and methods run on the main thread.

 This is important because SwiftUI updates must happen on the main thread.

 Prevents runtime issues or UI glitches when @Observable-tracked state changes.

 @Observable enables:

 Automatic observation and view updates when any var changes.

 Eliminates need for @Published or ObservableObject.
*/

@MainActor
@Observable
class RootViewModel {
    
    // @ObservationIgnored is a macro provided by Swift's new Observation framework (iOS 17+ / Swift 5.9+) that tells SwiftUI:
    // Don't track this property for changes.
    @ObservationIgnored
    @Injector var accountService: AccountService
    
    var isAuthenticated: Bool {
        accountService.currentUser != nil
    }
    
    var canShowLoader: Bool {
        accountService.isDataFetching
    }
}
