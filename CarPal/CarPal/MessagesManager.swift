import Foundation
import SwiftUI

// Message types
enum MessageType: Codable {
    case text
    case link(String)
    case invitation(TripInvitation)
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
        
        conversations["Oscar Tang"] = [
            Message(sender: "Oscar Tang", content: "Sure! See you at 8 AM tomorrow.", timestamp: Date().addingTimeInterval(-7200), type: .text)
        ]
        
        conversations["Mike Johnson"] = [
            Message(sender: "Mike Johnson", content: "Thanks for sharing!", timestamp: Date().addingTimeInterval(-3600), type: .text)
        ]
    }
}

// Legacy ChatMessage for compatibility
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSent: Bool
    let time: String
}
