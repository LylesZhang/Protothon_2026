import SwiftUI

struct MessagePreview: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let iconName: String
    let isGroup: Bool
}

struct MessagesView: View {
    @StateObject private var messagesManager = MessagesManager.shared
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    @State private var searchText = ""
    @State private var showSearchResults = false

    // Static messages for people without conversations yet
    private let staticMessages: [MessagePreview] = [
        MessagePreview(name: "Shaun Jin", lastMessage: "Anyone heading to downtown?", time: "5h ago", unreadCount: 5, iconName: "chat", isGroup: false),
        MessagePreview(name: "CarPal Assistant", lastMessage: "How can I help you today?", time: "1d ago", unreadCount: 0, iconName: "robot", isGroup: false),
        MessagePreview(name: "Jose Andres", lastMessage: "Thanks for the ride!", time: "2d ago", unreadCount: 0, iconName: "chat", isGroup: false),
    ]
    
    private var allMessages: [MessagePreview] {
        let dynamicMessages = messagesManager.getConversationPreviews().map { preview in
            MessagePreview(name: preview.name, lastMessage: preview.lastMessage, 
                   time: preview.time, unreadCount: preview.unreadCount, 
                   iconName: preview.iconName, isGroup: preview.isGroup)
        }
        
        // Combine and remove duplicates
        let allNames = Set(dynamicMessages.map { $0.name })
        let filteredStatic = staticMessages.filter { !allNames.contains($0.name) }
        
        return dynamicMessages + filteredStatic
    }

    // Searchable contacts (Followers + Following only)
    private let contacts: [String] = [
        "Oscar Tang", "Shaun Jin", "Jose Andres",
        "Sarah Chen", "Mike Johnson", "Amy Liu",
        "Carlos Ruiz", "Emma Wilson", "Alex Rivera",
    ]

    private var filteredContacts: [String] {
        guard !searchText.isEmpty else { return [] }
        return contacts.filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search contacts", text: $searchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()

            if !searchText.isEmpty {
                // Search results
                searchResultsList
            } else {
                // Message list
                messageList
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Message List

    private var messageList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(allMessages.enumerated()), id: \.element.id) { index, message in
                    messageRow(message)
                    if index < allMessages.count - 1 {
                        Divider().padding(.leading, 76)
                    }
                }
            }
            .padding(.bottom, 80)
        }
    }

    // MARK: - Search Results

    private var searchResultsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                if filteredContacts.isEmpty {
                    VStack(spacing: 8) {
                        Spacer().frame(height: 40)
                        Image(systemName: "person.slash")
                            .font(.system(size: 36))
                            .foregroundColor(.gray)
                        Text("No contacts found")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(filteredContacts, id: \.self) { contact in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color(.systemGray2))
                                )

                            Text(contact)
                                .font(.system(size: 16, weight: .medium))

                            Spacer()

                            Image(systemName: "message")
                                .foregroundStyle(brandBlue)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                        Divider().padding(.leading, 76)
                    }
                }
            }
            .padding(.bottom, 80)
        }
    }

    // MARK: - Message Row

    private func messageRow(_ message: MessagePreview) -> some View {
        NavigationLink {
            ChatView(contactName: message.name)
        } label: {
            HStack(spacing: 14) {
                // Avatar icon
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: message.iconName == "robot" ? "desktopcomputer" : "bubble.left.fill")
                            .font(.system(size: 20))
                            .foregroundColor(message.iconName == "robot" ? brandBlue : Color(.systemGray2))
                    )

                // Name + last message
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(message.lastMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                // Time + badge
                VStack(alignment: .trailing, spacing: 6) {
                    Text(message.time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    if message.unreadCount > 0 {
                        Text("\(message.unreadCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(brandBlue)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    NavigationStack {
        MessagesView()
    }
}
