import Foundation

class FollowManager: ObservableObject {
    static let shared = FollowManager()
    
    @Published var followedUsers: Set<String> = [
        "Oscar Tang",
        "Sarah Chen",
        "Mike Johnson"
    ]
    
    private init() {
        loadFollowedUsers()
    }
    
    func isFollowing(user: String) -> Bool {
        return followedUsers.contains(user)
    }
    
    func toggleFollow(user: String) {
        if followedUsers.contains(user) {
            followedUsers.remove(user)
            print("❌ Unfollowed \(user)")
        } else {
            followedUsers.insert(user)
            print("✅ Followed \(user)")
            
            // Create conversation with this user when following
            MessagesManager.shared.createConversationIfNeeded(with: user)
        }
        saveToPersistence()
    }
    
    func getFollowingTrips(from allTrips: [Trip]) -> [Trip] {
        return allTrips.filter { trip in
            followedUsers.contains(trip.author)
        }
    }
    
    private func loadFollowedUsers() {
        // In a real app, load from UserDefaults or database
        // For now, using preset followed users
    }
    
    private func saveToPersistence() {
        // In a real app, save to UserDefaults or database
    }
}
