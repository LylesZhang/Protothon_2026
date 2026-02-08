import Foundation
import SwiftUI

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
    
    @Published var conversations: [String: [ChatMessage]] = [:]
    
    private init() {
        loadInitialMessages()
    }
    
    func sendMessage(to person: String, text: String, isSent: Bool = true) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let timeString = formatter.string(from: Date())
        
        let message = ChatMessage(text: text, isSent: isSent, time: timeString)
        
        if conversations[person] == nil {
            conversations[person] = []
        }
        conversations[person]?.append(message)
    }
    
    func getMessages(for person: String) -> [ChatMessage] {
        return conversations[person] ?? []
    }
    
    func getLastMessage(for person: String) -> String {
        guard let messages = conversations[person], let last = messages.last else {
            return "No messages yet"
        }
        // Truncate long messages
        let text = last.text
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
        conversations["Sarah Chen"] = [
            ChatMessage(text: "Hi! Thanks for your interest in the trip!", isSent: false, time: "10:30 AM"),
            ChatMessage(text: "Hello! I saw your post and would love to join.", isSent: true, time: "10:32 AM"),
            ChatMessage(text: "That is great! Are you okay with the departure time?", isSent: false, time: "10:35 AM")
        ]
        
        conversations["Oscar Tang"] = [
            ChatMessage(text: "Sure! See you at 8 AM tomorrow.", isSent: false, time: "2h ago")
        ]
        
        conversations["Mike Johnson"] = [
            ChatMessage(text: "Thanks for sharing!", isSent: false, time: "1h ago")
        ]
    }
}
