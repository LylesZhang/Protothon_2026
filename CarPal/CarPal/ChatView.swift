import SwiftUI

struct ChatView: View {
    let contactName: String
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var messagesManager = MessagesManager.shared
    @StateObject private var invitationManager = TripInvitationManager.shared
    @StateObject private var postsManager = MyPostsManager.shared
    
    @State private var messageText = ""
    @State private var showTripSelector = false
    @State private var showRatingView = false
    @State private var currentRatingTripId: UUID?
    @State private var acceptedInvitationIds: Set<UUID> = []
    @State private var declinedInvitationIds: Set<UUID> = []
    
    private var messages: [Message] {
        messagesManager.getMessages(for: contactName)
    }
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
                
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(.systemGray2))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(contactName)
                        .font(.system(size: 16, weight: .semibold))
                    Text("ACTIVE NOW")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(tagGreen)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            
            Divider()
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageRow(
                                message: message,
                                brandBlue: brandBlue,
                                tagGreen: tagGreen,
                                acceptedInvitationIds: acceptedInvitationIds,
                                declinedInvitationIds: declinedInvitationIds,
                                onAcceptInvitation: { invitation in
                                    withAnimation {
                                        acceptedInvitationIds.insert(invitation.id)
                                    }
                                    invitationManager.acceptInvitation(invitation)
                                },
                                onDeclineInvitation: { invitation in
                                    withAnimation {
                                        declinedInvitationIds.insert(invitation.id)
                                    }
                                    invitationManager.declineInvitation(invitation)
                                },
                                onConfirmFinished: { tripId in
                                    invitationManager.confirmTripFinished(tripId, conversationId: contactName)
                                },
                                onShowRating: { tripId in
                                    currentRatingTripId = tripId
                                    showRatingView = true
                                }
                            )
                            .id(message.id)
                        }
                    }
                    .padding(16)
                }
                .onAppear {
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            HStack(spacing: 12) {
                // + button for sending invitations
                Button {
                    showTripSelector = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(brandBlue)
                }
                
                TextField("Message...", text: $messageText, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button {
                    if !messageText.isEmpty {
                        messagesManager.sendMessage(to: contactName, text: messageText, isSent: true)
                        messageText = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(messageText.isEmpty ? .gray : brandBlue)
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTripSelector) {
            TripSelectorView(contactName: contactName)
        }
        .sheet(isPresented: $showRatingView) {
            if let tripId = currentRatingTripId {
                RatingView(tripId: tripId, partnerName: contactName, conversationId: contactName)
            }
        }
    }
}

// MARK: - Message Row

struct MessageRow: View {
    let message: Message
    let brandBlue: Color
    let tagGreen: Color
    let acceptedInvitationIds: Set<UUID>
    let declinedInvitationIds: Set<UUID>
    let onAcceptInvitation: (TripInvitation) -> Void
    let onDeclineInvitation: (TripInvitation) -> Void
    let onConfirmFinished: (UUID) -> Void
    let onShowRating: (UUID) -> Void
    
    private var isSent: Bool {
        message.sender == "You"
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSent {
                Spacer()
            }
            
            VStack(alignment: isSent ? .trailing : .leading, spacing: 4) {
                // Message bubble based on type
                switch message.type {
                case .text:
                    TextMessageBubble(content: message.content, isSent: isSent, brandBlue: brandBlue)
                    
                case .link(let url):
                    LinkMessageBubble(content: message.content, url: url, isSent: isSent, brandBlue: brandBlue, tagGreen: tagGreen)
                    
                case .invitation(let invitation):
                    InvitationBubble(
                        invitation: invitation,
                        isSent: isSent,
                        isAccepted: acceptedInvitationIds.contains(invitation.id),
                        isDeclined: declinedInvitationIds.contains(invitation.id),
                        brandBlue: brandBlue,
                        tagGreen: tagGreen,
                        onAccept: { onAcceptInvitation(invitation) },
                        onDecline: { onDeclineInvitation(invitation) }
                    )
                    
                case .finishPrompt(let tripId):
                    FinishPromptBubble(tripId: tripId, onConfirm: onConfirmFinished)
                    
                case .ratingPrompt(let tripId):
                    RatingPromptBubble(tripId: tripId, partnerName: message.content, onRate: onShowRating)
                }
                
                // Timestamp
                Text(formatTimestamp(message.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            if !isSent {
                Spacer()
            }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Text Message Bubble

struct TextMessageBubble: View {
    let content: String
    let isSent: Bool
    let brandBlue: Color
    
    var body: some View {
        Text(content)
            .font(.system(size: 15))
            .foregroundColor(isSent ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSent ? brandBlue : Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

// MARK: - Link Message Bubble

struct LinkMessageBubble: View {
    let content: String
    let url: String
    let isSent: Bool
    let brandBlue: Color
    let tagGreen: Color
    
    var body: some View {
        Button {
            if let tripId = extractTripId(from: url) {
                // Navigate to trip detail
                print("Navigate to trip: \(tripId)")
            }
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("View Trip Details")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text(url)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: 250, alignment: .leading)
            .background(tagGreen)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
    
    private func extractTripId(from url: String) -> UUID? {
        guard let components = URLComponents(string: url),
              let idString = components.path.components(separatedBy: "/").last,
              let uuid = UUID(uuidString: idString) else {
            return nil
        }
        return uuid
    }
}

// MARK: - Invitation Bubble

struct InvitationBubble: View {
    let invitation: TripInvitation
    let isSent: Bool
    let isAccepted: Bool
    let isDeclined: Bool
    let brandBlue: Color
    let tagGreen: Color
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Partner Invitation")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                if !isSent {
                    Button {
                        // Dismiss
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(brandBlue)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text("Invitation for trip to:")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text(invitation.destination)
                    .font(.system(size: 16, weight: .bold))
                
                if !isSent {
                    if isAccepted {
                        // Accepted status
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(tagGreen)
                            Text("Accepted")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(tagGreen)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(tagGreen.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else if isDeclined {
                        // Declined status
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Declined")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        HStack(spacing: 8) {
                            // Accept button
                            Button {
                                onAccept()
                            } label: {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(tagGreen)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            // Decline button
                            Button {
                                onDecline()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.red.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
            }
            .padding(14)
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .frame(maxWidth: 280)
    }
}

// MARK: - Finish Prompt Bubble

struct FinishPromptBubble: View {
    let tripId: UUID
    let onConfirm: (UUID) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Did you finish the ride?")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.2))
            
            HStack(spacing: 12) {
                Button {
                    onConfirm(tripId)
                } label: {
                    Text("Yes")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color(red: 1.0, green: 0.6, blue: 0.0))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Button {
                    // No action
                } label: {
                    Text("No")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding(16)
        .background(Color(red: 1.0, green: 0.95, blue: 0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 1.0, green: 0.8, blue: 0.6), lineWidth: 2)
        )
        .frame(maxWidth: 280)
    }
}

// MARK: - Rating Prompt Bubble

struct RatingPromptBubble: View {
    let tripId: UUID
    let partnerName: String
    let onRate: (UUID) -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "star.fill")
                .font(.system(size: 30))
                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
            
            Text("How was your trip with \(partnerName)?")
                .font(.system(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
            
            Button {
                onRate(tripId)
            } label: {
                Text("Rate Now")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 1.0, green: 0.8, blue: 0.0))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 1.0, green: 0.8, blue: 0.0), lineWidth: 2)
        )
        .frame(maxWidth: 240)
    }
}

// MARK: - Trip Selector View

struct TripSelectorView: View {
    let contactName: String
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var postsManager = MyPostsManager.shared
    @StateObject private var invitationManager = TripInvitationManager.shared
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(postsManager.myPosts) { trip in
                        Button {
                            invitationManager.sendInvitation(trip: trip, to: contactName, conversationId: contactName)
                            dismiss()
                        } label: {
                            TripSelectorCard(trip: trip)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Select a Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Trip Selector Card

struct TripSelectorCard: View {
    let trip: Trip
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: symbolName(for: trip.imageName))
                        .foregroundColor(Color(.systemGray2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(trip.origin) → \(trip.location)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Text(trip.date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
    
    private func symbolName(for imageName: String) -> String {
        switch imageName {
        case "mountain": return "mountain.2.fill"
        case "coast": return "water.waves"
        case "city": return "building.2.fill"
        case "desert": return "sun.max.fill"
        case "forest": return "leaf.fill"
        case "airport": return "airplane"
        case "shopping": return "cart.fill"
        case "food": return "fork.knife"
        case "campus": return "graduationcap.fill"
        case "beach": return "beach.umbrella.fill"
        default: return "car.fill"
        }
    }
}

// MARK: - Rating View

struct RatingView: View {
    let tripId: UUID
    let partnerName: String
    let conversationId: String
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var invitationManager = TripInvitationManager.shared
    
    @State private var selectedRating: Int = 0
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                
                Text("How was your trip with \(partnerName)?")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Star rating
                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { rating in
                        Button {
                            selectedRating = rating
                        } label: {
                            Image(systemName: rating <= selectedRating ? "star.fill" : "star")
                                .font(.system(size: 40))
                                .foregroundColor(rating <= selectedRating ? Color(red: 1.0, green: 0.8, blue: 0.0) : Color(.systemGray4))
                        }
                    }
                }
                .padding(.vertical, 20)
                
                Button {
                    if selectedRating > 0 {
                        invitationManager.submitRating(selectedRating, for: tripId, conversationId: conversationId, partnerName: partnerName)
                        dismiss()
                    }
                } label: {
                    Text("Submit Rating")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selectedRating > 0 ? Color(red: 1.0, green: 0.8, blue: 0.0) : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(selectedRating == 0)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("Rate Your Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
