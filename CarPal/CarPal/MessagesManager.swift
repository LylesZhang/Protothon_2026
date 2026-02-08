import Foundation
import SwiftUI

// Message types
enum MessageType: Codable {
    case text
    case link(String)
    case invitation(TripInvitation)
    case joinRequest(JoinRequest)
    case finishPrompt(UUID)
    case ratingPrompt(UUID)
}

// Updated Message model
struct Message: Identifiable, Codable {
    let id: UUID
    let sender: String
    let content: String
    let timestamp: Date
    let type: MessageType
    
    init(id: UUID = UUID(), sender: String, content: String, timestamp: Date, type: MessageType = .text) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.type = type
    }
}

// Conversation preview for MessagesView
struct ConversationPreview: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let iconName: String
    let isGroup: Bool
}

// Global message manager for chat functionality
class MessagesManager: ObservableObject {
    static let shared = MessagesManager()
    
    @Published var conversations: [String: [Message]] = [:]
    
    private init() {
        loadInitialMessages()
    }
    
    func sendMessage(_ message: Message, to person: String) {
        if conversations[person] == nil {
            conversations[person] = []
        }
        conversations[person]?.append(message)
    }
    
    func sendMessage(to person: String, text: String, isSent: Bool = true) {
        let message = Message(
            sender: isSent ? "You" : person,
            content: text,
            timestamp: Date(),
            type: text.hasPrefix("carpal://") ? .link(text) : .text
        )
        sendMessage(message, to: person)
    }
    
    func getMessages(for person: String) -> [Message] {
        return conversations[person] ?? []
    }
    
    func getLastMessage(for person: String) -> String {
        guard let messages = conversations[person], let last = messages.last else {
            return "No messages yet"
        }
        // Truncate long messages
        let text = last.content
        return text.count > 50 ? String(text.prefix(50)) + "..." : text
    }
    
    func getConversationPreviews() -> [ConversationPreview] {
        // Get all conversation names and sort by most recent
        let allPeople = ["Sarah Chen", "Oscar Tang", "Shaun Jin", "Mike Johnson", 
                        "Emma Wilson", "Alex Rivera", "Jose Andres", "Amy Liu", "Carlos Ruiz"]
        
        return allPeople.compactMap { person in
            guard conversations[person] != nil else { return nil }
            return ConversationPreview(
                name: person,
                lastMessage: getLastMessage(for: person),
                time: "Just now",
                unreadCount: 0,
                iconName: "chat",
                isGroup: false
            )
        }
    }
    
    func createConversationIfNeeded(with person: String) {
        if conversations[person] == nil {
            conversations[person] = []
            print("💬 Created new conversation with \(person)")
        }
    }
    
    private func loadInitialMessages() {
        // Load some sample messages
        
        // Create a sample invitation from Sarah Chen
        let nycTripInvitation = TripInvitation(
            tripId: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            tripTitle: "NYC Weekend Adventure",
            destination: "New York City, NY",
            origin: "Haverford College",
            departureTime: "8:00 AM - 9:00 AM",
            invitedUser: "You",
            conversationId: "Sarah Chen"
        )
        
        conversations["Sarah Chen"] = [
            Message(sender: "Sarah Chen", content: "Hi! Thanks for your interest in the trip!", timestamp: Date().addingTimeInterval(-7200), type: .text),
            Message(sender: "You", content: "Hello! I saw your post and would love to join.", timestamp: Date().addingTimeInterval(-7080), type: .text),
            Message(sender: "Sarah Chen", content: "That is great! Are you okay with the departure time?", timestamp: Date().addingTimeInterval(-6900), type: .text),
            Message(sender: "You", content: "Yes, perfect timing for me!", timestamp: Date().addingTimeInterval(-6800), type: .text),
            Message(sender: "Sarah Chen", content: "Awesome! Let me send you an official invitation.", timestamp: Date().addingTimeInterval(-3600), type: .text),
            Message(sender: "Sarah Chen", content: "Partner Invitation", timestamp: Date().addingTimeInterval(-3500), type: .invitation(nycTripInvitation))
        ]
        
        // Oscar Tang wants to join user's trips
        let oscarNycJoinRequest = JoinRequest(
            tripId: MyPostsManager.shared.myPosts.first?.id ?? UUID(),
            tripTitle: "Weekend NYC Trip",
            destination: "New York City, NY",
            origin: "Haverford College",
            requesterName: "Oscar Tang",
            conversationId: "Oscar Tang"
        )
        
        let oscarPhillyJoinRequest = JoinRequest(
            tripId: MyPostsManager.shared.myPosts.last?.id ?? UUID(),
            tripTitle: "Philly Center City Shopping",
            destination: "Center City Philadelphia",
            origin: "Bryn Mawr College",
            requesterName: "Oscar Tang",
            conversationId: "Oscar Tang"
        )
        
        conversations["Oscar Tang"] = [
            Message(sender: "Oscar Tang", content: "Hi Lyles! I saw your NYC trip post.", timestamp: Date().addingTimeInterval(-10800), type: .text),
            Message(sender: "Oscar Tang", content: "I'm also planning to go to NYC that weekend and would love to join if there's still space!", timestamp: Date().addingTimeInterval(-10700), type: .text),
            Message(sender: "You", content: "Hey Oscar! Sure, I still have spots available.", timestamp: Date().addingTimeInterval(-10500), type: .text),
            Message(sender: "Oscar Tang", content: "That's great! The departure time works perfectly for me.", timestamp: Date().addingTimeInterval(-10400), type: .text),
            Message(sender: "You", content: "Perfect! Let me send you a formal request to join.", timestamp: Date().addingTimeInterval(-10200), type: .text),
            Message(sender: "Oscar Tang", content: "Join Request", timestamp: Date().addingTimeInterval(-10000), type: .joinRequest(oscarNycJoinRequest)),
            Message(sender: "You", content: "Approved! See you at 8 AM!", timestamp: Date().addingTimeInterval(-9800), type: .text),
            Message(sender: "Oscar Tang", content: "Awesome! Thanks! Looking forward to it.", timestamp: Date().addingTimeInterval(-9600), type: .text),
            Message(sender: "Oscar Tang", content: "Hey! Also saw your Philly shopping trip on the 20th.", timestamp: Date().addingTimeInterval(-7200), type: .text),
            Message(sender: "Oscar Tang", content: "Mind if I join that one too? Need to grab some things in the city.", timestamp: Date().addingTimeInterval(-7100), type: .text),
            Message(sender: "You", content: "Of course! Happy to have you along.", timestamp: Date().addingTimeInterval(-7000), type: .text),
            Message(sender: "Oscar Tang", content: "Join Request", timestamp: Date().addingTimeInterval(-6900), type: .joinRequest(oscarPhillyJoinRequest)),
            Message(sender: "You", content: "Request approved! See you on the 20th at 2 PM!", timestamp: Date().addingTimeInterval(-6800), type: .text),
            Message(sender: "Oscar Tang", content: "Perfect! Thanks again!", timestamp: Date().addingTimeInterval(-6700), type: .text)
        ]
        
        conversations["Mike Johnson"] = [
            Message(sender: "Mike Johnson", content: "Thanks for sharing!", timestamp: Date().addingTimeInterval(-3600), type: .text)
        ]
        
        // Initialize empty conversations for other users to avoid blank screen
        let otherUsers = ["Emma Wilson", "Alex Rivera", "Shaun Jin", "Jose Andres", "Amy Liu", "Carlos Ruiz"]
        for user in otherUsers {
            if conversations[user] == nil {
                conversations[user] = []
            }
        }
    }
}

// Legacy ChatMessage for compatibility
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSent: Bool
    let time: String
}
