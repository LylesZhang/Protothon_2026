import Foundation

class MyPostsManager: ObservableObject {
    static let shared = MyPostsManager()
    
    @Published var myPosts: [Trip] = [
        Trip(
            title: "Mountain Road Trip Adventure",
            location: "Lake Tahoe, CA",
            setOff: "8:00 AM",
            arrived: "12:30 PM",
            tags: ["Pet Allow", "Prefer Female", "No Smoking"],
            author: "Sarah Chen",
            date: "Feb 5, 2026",
            imageName: "mountain"
        ),
        Trip(
            title: "Forest Road Nature Escape",
            location: "Big Sur, CA",
            setOff: "9:00 AM",
            arrived: "2:30 PM",
            tags: ["Pet Allow", "Music OK", "Luggage Space"],
            author: "Sarah Chen",
            date: "Feb 2, 2026",
            imageName: "forest"
        ),
    ]
    
    func updatePost(_ updatedTrip: Trip) {
        print("📦 MyPostsManager: Updating post \(updatedTrip.id)")
        print("🏷️ New tags: \(updatedTrip.tags)")
        if let index = myPosts.firstIndex(where: { $0.id == updatedTrip.id }) {
            myPosts[index] = updatedTrip
            print("✅ Post updated at index \(index)")
            print("🏷️ Saved tags: \(myPosts[index].tags)")
        } else {
            print("❌ Post not found!")
        }
    }
    
    func deletePost(_ tripId: UUID) {
        myPosts.removeAll { $0.id == tripId }
    }
    
    func getPost(by id: UUID) -> Trip? {
        return myPosts.first { $0.id == id }
    }
}
