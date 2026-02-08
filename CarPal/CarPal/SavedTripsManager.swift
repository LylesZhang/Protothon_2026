import Foundation
import SwiftUI

// Global state manager for saved trips
class SavedTripsManager: ObservableObject {
    static let shared = SavedTripsManager()
    
    @Published var savedTripIds: Set<UUID> = []
    
    private init() {
        loadSavedTrips()
    }
    
    func toggleSave(tripId: UUID) {
        if savedTripIds.contains(tripId) {
            savedTripIds.remove(tripId)
        } else {
            savedTripIds.insert(tripId)
        }
        saveToPersistence()
    }
    
    func isSaved(tripId: UUID) -> Bool {
        return savedTripIds.contains(tripId)
    }
    
    func getSavedTrips(from allTrips: [Trip]) -> [Trip] {
        return allTrips.filter { savedTripIds.contains($0.id) }
    }
    
    private func loadSavedTrips() {
        // In a real app, load from UserDefaults or database
        // For now, just initialize empty
    }
    
    private func saveToPersistence() {
        // In a real app, save to UserDefaults or database
    }
}
