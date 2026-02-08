import Foundation
import SwiftUI

class TripsManager: ObservableObject {
    static let shared = TripsManager()
    
    @Published var allTrips: [Trip] = []
    
    private init() {
        // Initialize with sample data
        allTrips = SampleData.recommendedTrips + SampleData.followingTrips
    }
    
    func getTrip(by id: UUID) -> Trip? {
        return allTrips.first { $0.id == id }
    }
    
    func updateTrip(_ updatedTrip: Trip) {
        if let index = allTrips.firstIndex(where: { $0.id == updatedTrip.id }) {
            allTrips[index] = updatedTrip
        }
    }
    
    func incrementParticipants(for tripId: UUID) {
        if let index = allTrips.firstIndex(where: { $0.id == tripId }) {
            allTrips[index].currentParticipants += 1
        }
    }
}
