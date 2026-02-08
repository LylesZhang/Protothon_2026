import Foundation
import SwiftUI

// Global state manager for saved trips
class SavedTripsManager: ObservableObject {
    static let shared = SavedTripsManager()
    
    @Published var savedTripIds: Set<UUID> = []
    @Published var savedTrips: [Trip] = []
    
    private init() {
        loadSavedTrips()
    }
    
    func toggleSave(tripId: UUID) {
        if savedTripIds.contains(tripId) {
            savedTripIds.remove(tripId)
            savedTrips.removeAll { $0.id == tripId }
        } else {
            savedTripIds.insert(tripId)
            // Try to find the trip from various sources
            if let trip = findTrip(by: tripId) {
                savedTrips.append(trip)
            }
        }
        saveToPersistence()
    }
    
    func isSaved(tripId: UUID) -> Bool {
        return savedTripIds.contains(tripId)
    }
    
    func getSavedTrips(from allTrips: [Trip]) -> [Trip] {
        return allTrips.filter { savedTripIds.contains($0.id) }
    }
    
    func getSavedTrips() -> [Trip] {
        return savedTrips
    }
    
    // Refresh a saved trip when it's updated in source
    func refreshSavedTrip(tripId: UUID) {
        if savedTripIds.contains(tripId) {
            // Find the updated trip from source
            if let updatedTrip = findTrip(by: tripId),
               let index = savedTrips.firstIndex(where: { $0.id == tripId }) {
                savedTrips[index] = updatedTrip
                print("✅ SavedTripsManager: Refreshed saved trip at index \(index)")
            }
        }
    }
    
    private func findTrip(by id: UUID) -> Trip? {
        // Search in TripsManager
        if let trip = TripsManager.shared.getTrip(by: id) {
            return trip
        }
        // Search in MyPostsManager
        if let trip = MyPostsManager.shared.getPost(by: id) {
            return trip
        }
        return nil
    }
    
    private func loadSavedTrips() {
        // In a real app, load from UserDefaults or database
        // For now, just initialize empty
    }
    
    private func saveToPersistence() {
        // In a real app, save to UserDefaults or database
    }
}
