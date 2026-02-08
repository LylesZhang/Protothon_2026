import Foundation

class MyPostsManager: ObservableObject {
    static let shared = MyPostsManager()
    
    @Published var myPosts: [Trip] = [
        Trip(
            title: "Weekend NYC Trip",
            origin: "Haverford College",
            location: "New York City, NY",
            setOff: "8:00 AM",
            arrived: "10:30 AM",
            tags: ["Music OK", "Chat Welcome", "No Smoking"],
            author: "Lyles Zhang",
            date: "Feb 5, 2026",
            imageName: "city"
        ),
        Trip(
            title: "Philly Center City Shopping",
            origin: "Bryn Mawr College",
            location: "Center City Philadelphia",
            setOff: "2:00 PM",
            arrived: "2:40 PM",
            tags: ["Music OK", "Chat Welcome"],
            author: "Lyles Zhang",
            date: "Feb 2, 2026",
            imageName: "shopping"
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
