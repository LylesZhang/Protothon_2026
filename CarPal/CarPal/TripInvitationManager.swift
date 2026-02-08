import Foundation
import SwiftUI

class TripInvitationManager: ObservableObject {
    static let shared = TripInvitationManager()
    
    @Published var activeInvitations: [TripInvitation] = []
    @Published var acceptedTrips: [AcceptedTrip] = []
    @Published var tripParticipants: [UUID: [TripParticipant]] = [:]
    @Published var activeJoinRequests: [JoinRequest] = []
    
    func sendInvitation(trip: Trip, to user: String, conversationId: String) {
        let invitation = TripInvitation(
            tripId: trip.id,
            tripTitle: trip.title,
            destination: trip.location,
            origin: trip.origin,
            departureTime: trip.setOff,
            invitedUser: user,
            conversationId: conversationId
        )
        activeInvitations.append(invitation)
        
        // Send invitation message
        let invitationMessage = Message(
            sender: "You",
            content: "Partner Invitation",
            timestamp: Date(),
            type: .invitation(invitation)
        )
        MessagesManager.shared.sendMessage(invitationMessage, to: conversationId)
    }
    
    func acceptInvitation(_ invitation: TripInvitation) {
        // Remove from active invitations
        activeInvitations.removeAll { $0.id == invitation.id }
        
        // Create accepted trip
        let acceptedTrip = AcceptedTrip(
            tripId: invitation.tripId,
            invitationId: invitation.id,
            conversationId: invitation.conversationId,
            status: .accepted
        )
        acceptedTrips.append(acceptedTrip)
        
        // Update trip participant count in MyPosts if it's user's own post
        if let index = MyPostsManager.shared.myPosts.firstIndex(where: { $0.id == invitation.tripId }) {
            var updatedTrip = MyPostsManager.shared.myPosts[index]
            updatedTrip.currentParticipants += 1
            MyPostsManager.shared.myPosts[index] = updatedTrip
        }
        
        // Also update in TripsManager for other people's trips
        TripsManager.shared.incrementParticipants(for: invitation.tripId)
        
        // Add participant to the trip
        let participant = TripParticipant(
            name: invitation.conversationId,  // Using conversationId as name for now
            joinedDate: Date()
        )
        if tripParticipants[invitation.tripId] == nil {
            tripParticipants[invitation.tripId] = []
        }
        tripParticipants[invitation.tripId]?.append(participant)
        
        // Simulate trip flow
        simulateTripFlow(acceptedTrip)
    }
    
    func declineInvitation(_ invitation: TripInvitation) {
        activeInvitations.removeAll { $0.id == invitation.id }
    }
    
    func sendJoinRequest(trip: Trip, from requester: String, to tripAuthor: String) {
        let request = JoinRequest(
            tripId: trip.id,
            tripTitle: trip.title,
            destination: trip.location,
            origin: trip.origin,
            requesterName: requester,
            conversationId: tripAuthor
        )
        activeJoinRequests.append(request)
        
        // Send join request message
        let requestMessage = Message(
            sender: requester,
            content: "Join Request",
            timestamp: Date(),
            type: .joinRequest(request)
        )
        MessagesManager.shared.sendMessage(requestMessage, to: tripAuthor)
    }
    
    func acceptJoinRequest(_ request: JoinRequest) {
        // Remove from active requests
        activeJoinRequests.removeAll { $0.id == request.id }
        
        // Add participant to the trip
        let participant = TripParticipant(
            name: request.requesterName,
            joinedDate: Date()
        )
        if tripParticipants[request.tripId] == nil {
            tripParticipants[request.tripId] = []
        }
        tripParticipants[request.tripId]?.append(participant)
        
        // Update trip participant count in MyPosts if it's user's own post
        if let index = MyPostsManager.shared.myPosts.firstIndex(where: { $0.id == request.tripId }) {
            MyPostsManager.shared.myPosts[index].currentParticipants += 1
        }
        
        // Also update in TripsManager
        TripsManager.shared.incrementParticipants(for: request.tripId)
        
        // Send acceptance confirmation message
        let confirmMessage = Message(
            sender: "You",
            content: "Great! Your request to join the trip has been accepted. See you there! 🚗",
            timestamp: Date(),
            type: .text
        )
        MessagesManager.shared.sendMessage(confirmMessage, to: request.requesterName)
    }
    
    func declineJoinRequest(_ request: JoinRequest) {
        // Remove from active requests
        activeJoinRequests.removeAll { $0.id == request.id }
        
        // Optionally send a decline message
        let declineMessage = Message(
            sender: "You",
            content: "Sorry, the trip is full or doesn't match your requirements at this time.",
            timestamp: Date(),
            type: .text
        )
        MessagesManager.shared.sendMessage(declineMessage, to: request.requesterName)
    }
    
    func getParticipants(for tripId: UUID) -> [TripParticipant] {
        return tripParticipants[tripId] ?? []
    }
    
    private init() {
        // Add some sample participants for demo
        loadSampleParticipants()
    }
    
    private func simulateTripFlow(_ acceptedTrip: AcceptedTrip) {
        // After 3 seconds, send "finished ride?" message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
            let finishMessage = Message(
                sender: "System",
                content: "Did you finish the ride?",
                timestamp: Date(),
                type: .finishPrompt(acceptedTrip.tripId)
            )
            MessagesManager.shared.sendMessage(finishMessage, to: acceptedTrip.conversationId)
            
            // Update status
            if let index = self.acceptedTrips.firstIndex(where: { $0.id == acceptedTrip.id }) {
                self.acceptedTrips[index].status = .waitingConfirmation
            }
        }
    }
    
    func confirmTripFinished(_ tripId: UUID, conversationId: String) {
        // Mark trip as finished
        if let index = acceptedTrips.firstIndex(where: { $0.tripId == tripId }) {
            acceptedTrips[index].status = .finished
        }
        
        // Send rating prompt
        let ratingMessage = Message(
            sender: "System",
            content: "How was your trip with Sarah?",
            timestamp: Date(),
            type: .ratingPrompt(tripId)
        )
        MessagesManager.shared.sendMessage(ratingMessage, to: conversationId)
    }
    
    func submitRating(_ rating: Int, for tripId: UUID, conversationId: String, partnerName: String) {
        // Send rating confirmation message
        let confirmMessage = Message(
            sender: "You",
            content: "Rated \(rating) stars! Thanks for the great trip.",
            timestamp: Date(),
            type: .text
        )
        MessagesManager.shared.sendMessage(confirmMessage, to: conversationId)
        
        // Update partner's rating (in real app, would update database)
        print("⭐️ Rated \(partnerName): \(rating) stars")
        
        // Mark invitation as completed
        if let index = acceptedTrips.firstIndex(where: { $0.tripId == tripId }) {
            acceptedTrips[index].status = .rated
        }
    }
    
    private func loadSampleParticipants() {
        // Add sample participants for the NYC trip (from MyPostsManager)
        // UUID for "Weekend NYC Trip"
        if let nycTrip = MyPostsManager.shared.myPosts.first(where: { $0.title == "Weekend NYC Trip" }) {
            tripParticipants[nycTrip.id] = [
                TripParticipant(name: "Emma Wilson", joinedDate: Date().addingTimeInterval(-86400 * 2)),
                TripParticipant(name: "Michael Brown", joinedDate: Date().addingTimeInterval(-86400))
            ]
        }
        
        // Add sample participants for Philly trip
        if let phillyTrip = MyPostsManager.shared.myPosts.first(where: { $0.title == "Philly Center City Shopping" }) {
            tripParticipants[phillyTrip.id] = [
                TripParticipant(name: "Sarah Chen", joinedDate: Date().addingTimeInterval(-3600 * 5))
            ]
        }
    }
}

// MARK: - Models

struct TripInvitation: Identifiable, Codable {
    let id: UUID
    let tripId: UUID
    let tripTitle: String
    let destination: String
    let origin: String
    let departureTime: String
    let invitedUser: String
    let conversationId: String
    let timestamp: Date
    
    init(id: UUID = UUID(), tripId: UUID, tripTitle: String, destination: String, origin: String, departureTime: String, invitedUser: String, conversationId: String) {
        self.id = id
        self.tripId = tripId
        self.tripTitle = tripTitle
        self.destination = destination
        self.origin = origin
        self.departureTime = departureTime
        self.invitedUser = invitedUser
        self.conversationId = conversationId
        self.timestamp = Date()
    }
}

struct AcceptedTrip: Identifiable {
    let id: UUID
    let tripId: UUID
    let invitationId: UUID
    let conversationId: String
    var status: TripStatus
    
    init(id: UUID = UUID(), tripId: UUID, invitationId: UUID, conversationId: String, status: TripStatus) {
        self.id = id
        self.tripId = tripId
        self.invitationId = invitationId
        self.conversationId = conversationId
        self.status = status
    }
}

enum TripStatus {
    case accepted
    case waitingConfirmation
    case finished
    case rated
}

struct TripParticipant: Identifiable {
    let id: UUID
    let name: String
    let joinedDate: Date
    
    init(id: UUID = UUID(), name: String, joinedDate: Date) {
        self.id = id
        self.name = name
        self.joinedDate = joinedDate
    }
}

struct JoinRequest: Identifiable, Codable {
    let id: UUID
    let tripId: UUID
    let tripTitle: String
    let destination: String
    let origin: String
    let requesterName: String
    let conversationId: String
    let timestamp: Date
    
    init(id: UUID = UUID(), tripId: UUID, tripTitle: String, destination: String, origin: String, requesterName: String, conversationId: String) {
        self.id = id
        self.tripId = tripId
        self.tripTitle = tripTitle
        self.destination = destination
        self.origin = origin
        self.requesterName = requesterName
        self.conversationId = conversationId
        self.timestamp = Date()
    }
}
