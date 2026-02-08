import SwiftUI

struct TripDetailView: View {
    let tripId: UUID
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var savedTripsManager = SavedTripsManager.shared
    @StateObject private var tripsManager = TripsManager.shared
    @StateObject private var invitationManager = TripInvitationManager.shared
    @StateObject private var myPostsManager = MyPostsManager.shared
    @State private var showComments = false
    @State private var showShareSheet = false
    @State private var isLiked = false
    @State private var likesCount: Int
    @State private var navigateToMessages = false
    @State private var showJoinRequestConfirmation = false
    
    private var trip: Trip {
        // Try to get from TripsManager first
        if let trip = tripsManager.getTrip(by: tripId) {
            return trip
        }
        // Then try MyPostsManager for user's own posts
        if let trip = myPostsManager.getPost(by: tripId) {
            return trip
        }
        // Fallback to Unknown Trip
        return Trip(
            title: "Unknown Trip",
            location: "Unknown",
            setOff: "N/A",
            arrived: "N/A",
            tags: [],
            author: "Unknown",
            date: "N/A",
            imageName: "car"
        )
    }
    
    init(trip: Trip) {
        self.tripId = trip.id
        _likesCount = State(initialValue: trip.likes)
    }
    
    private var isSaved: Bool {
        savedTripsManager.isSaved(tripId: tripId)
    }
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    // Map image names to SF Symbols
    private var symbolName: String {
        switch trip.imageName {
        case "mountain": return "mountain.2.fill"
        case "coast": return "water.waves"
        case "city": return "building.2.fill"
        case "desert": return "sun.max.fill"
        case "airport": return "airplane"
        case "shopping": return "cart.fill"
        case "food": return "fork.knife"
        case "campus": return "graduationcap.fill"
        case "beach": return "beach.umbrella.fill"
        default: return "car.fill"
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Image
                    heroImage
                    
                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        Text(trip.title)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.top, 20)
                        
                        // Poster Detail
                        posterSection
                        
                        Divider()
                        
                        // Trip Detail
                        tripDetailSection
                        
                        Divider()
                        
                        // Description
                        descriptionSection
                        
                        Divider()
                        
                        // Requirements
                        requirementsSection
                        
                        Divider()
                        
                        // Status
                        statusSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            
            // Toolbar at bottom
            VStack {
                Spacer()
                toolbar
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $showComments) {
            CommentsView(tripTitle: trip.title)
        }
        .sheet(isPresented: $showShareSheet) {
            SharePostView(tripTitle: trip.title, tripId: tripId)
        }
        .navigationDestination(isPresented: $navigateToMessages) {
            ChatView(contactName: trip.author)
        }
        .alert("Request Sent!", isPresented: $showJoinRequestConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your join request has been sent to \(trip.author). You'll be notified when they respond.")
        }
    }
    
    private func sendJoinRequest() {
        // Send join request message to the trip author
        invitationManager.sendJoinRequest(trip: trip, from: "You", to: trip.author)
        showJoinRequestConfirmation = true
    }
    
    // MARK: - Hero Image
    
    private var heroImage: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color(.systemGray5))
            .frame(height: 240)
            .overlay(
                Image(systemName: symbolName)
                    .font(.system(size: 60))
                    .foregroundStyle(Color(.systemGray2))
            )
    }
    
    // MARK: - Poster Section
    
    private var posterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Poster")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(.systemGray2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(trip.author) (\(trip.authorPronoun))")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < Int(trip.authorRating) ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(i < Int(trip.authorRating) ? .yellow : Color(.systemGray4))
                        }
                        Text(String(format: "%.1f", trip.authorRating))
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            
            // College, Year, Gender
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("School:")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(trip.authorCollege)
                        .font(.system(size: 14, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Year:")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(trip.authorYear)
                        .font(.system(size: 14, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Gender:")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(trip.authorGender)
                        .font(.system(size: 14, weight: .medium))
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Trip Detail Section
    
    private var tripDetailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trip Details")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(brandBlue)
                    Text("From:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(trip.origin)
                        .font(.system(size: 15, weight: .medium))
                }
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(brandBlue)
                    Text("Destination:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(trip.location)
                        .font(.system(size: 15, weight: .medium))
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(brandBlue)
                    Text("Departure:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("\(trip.date), \(trip.setOff)")
                        .font(.system(size: 15, weight: .medium))
                }
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(brandBlue)
                    Text("Arrival:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("\(trip.date), \(trip.arrived)")
                        .font(.system(size: 15, weight: .medium))
                }
            }
        }
    }
    
    // MARK: - Description Section
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            Text(trip.description)
                .font(.system(size: 15))
                .lineSpacing(4)
        }
    }
    
    // MARK: - Requirements Section
    
    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requirements")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            FlowLayout(spacing: 8) {
                ForEach(trip.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(tagGreen)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(tagGreen.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            if trip.isFinished {
                HStack(spacing: 8) {
                    Circle()
                        .fill(.gray)
                        .frame(width: 12, height: 12)
                    
                    Text("Trip already finished")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                HStack(spacing: 8) {
                    Circle()
                        .fill(trip.currentParticipants >= trip.capacity ? .red : tagGreen)
                        .frame(width: 12, height: 12)
                    
                    Text(trip.currentParticipants >= trip.capacity ? "Full" : "Available")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(trip.currentParticipants >= trip.capacity ? .red : tagGreen)
                    
                    Spacer()
                    
                    Text("\(trip.currentParticipants) / \(trip.capacity) people")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Likes count
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                Text("\(likesCount) likes")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Toolbar
    
    private var toolbar: some View {
        HStack(spacing: 0) {
            // Comment
            Button {
                showComments = true
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 20))
                    Text("Comment")
                        .font(.system(size: 11))
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            }
            
            // Request to Join
            Button {
                sendJoinRequest()
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 20))
                    Text("Join")
                        .font(.system(size: 11))
                }
                .foregroundColor(brandBlue)
                .frame(maxWidth: .infinity)
            }
            
            // DM
            Button {
                navigateToMessages = true
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "envelope")
                        .font(.system(size: 20))
                    Text("DM")
                        .font(.system(size: 11))
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            }
            
            // Like
            Button {
                isLiked.toggle()
                if isLiked {
                    likesCount += 1
                } else {
                    likesCount -= 1
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(isLiked ? .red : .primary)
                    Text("Like")
                        .font(.system(size: 11))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Save
            Button {
                savedTripsManager.toggleSave(tripId: tripId)
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20))
                        .foregroundColor(isSaved ? brandBlue : .primary)
                    Text("Save")
                        .font(.system(size: 11))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Share
            Button {
                showShareSheet = true
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                    Text("Share")
                        .font(.system(size: 11))
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            }
            
            // Report
            Button {
                // TODO: Report functionality
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 20))
                    Text("Report")
                        .font(.system(size: 11))
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .overlay(
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.5),
            alignment: .top
        )
    }
    
    // MARK: - Helper Functions
    
    private func addTimeWindow(_ time: String) -> String {
        // Add 30 minutes to create a time window
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if let date = formatter.date(from: time) {
            let newDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)
            if let newDate = newDate {
                return formatter.string(from: newDate)
            }
        }
        return time
    }
}

// MARK: - Comments View

struct CommentsView: View {
    let tripTitle: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var commentText = ""
    @State private var comments: [Comment] = [
        Comment(
            authorName: "Mike Johnson",
            text: "This sounds perfect! I am interested in joining.",
            time: "2h ago",
            replies: [
                Reply(authorName: "Sarah Chen", text: "Great! Send me a message and we can discuss details.", time: "1h ago")
            ]
        ),
        Comment(
            authorName: "Emma Wilson",
            text: "Do you have space for one more person?",
            time: "5h ago",
            replies: []
        )
    ]
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Comments list
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(comments) { comment in
                            CommentRow(comment: comment)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 80)
                }
                
                // Input area
                HStack(spacing: 12) {
                    TextField("Add a comment...", text: $commentText, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button {
                        if !commentText.isEmpty {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "h:mm a"
                            let timeString = formatter.string(from: Date())
                            let relativeTime = "Just now"
                            
                            comments.append(Comment(
                                authorName: "You",
                                text: commentText,
                                time: relativeTime,
                                replies: []
                            ))
                            commentText = ""
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(commentText.isEmpty ? .gray : brandBlue)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color(.systemGray6)))
                    }
                    .disabled(commentText.isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Comment Row

struct CommentRow: View {
    let comment: Comment
    @State private var showReplyInput = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(.systemGray2))
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(comment.authorName)
                            .font(.system(size: 15, weight: .semibold))
                        Text(comment.time)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Text(comment.text)
                        .font(.system(size: 15))
                    
                    Button {
                        showReplyInput.toggle()
                    } label: {
                        Text("Reply")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.231, green: 0.357, blue: 0.906))
                    }
                }
            }
            
            // Replies
            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(comment.replies) { reply in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "arrow.turn.down.right")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.systemGray2))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(reply.authorName)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(reply.time)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                Text(reply.text)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Share Post View

struct SharePostView: View {
    let tripTitle: String
    let tripId: UUID
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPeople: Set<String> = []
    @State private var searchText = ""
    @State private var showAlert = false
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let allPeople = ["Mike Johnson", "Emma Wilson", "Alex Rivera", "James Park", "Lisa Thompson", 
                             "Sarah Chen", "Oscar Tang", "Shaun Jin", "Jose Andres", "Amy Liu", "Carlos Ruiz"]
    
    private var filteredPeople: [String] {
        if searchText.isEmpty {
            return allPeople
        }
        return allPeople.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sharing:")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(tripTitle)
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color(.systemGray6))
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search people", text: $searchText)
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
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                Text("Select people to share with:")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                
                // People list
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredPeople, id: \.self) { person in
                            Button {
                                if selectedPeople.contains(person) {
                                    selectedPeople.remove(person)
                                } else {
                                    selectedPeople.insert(person)
                                }
                            } label: {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(Color(.systemGray2))
                                        )
                                    
                                    Text(person)
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .stroke(selectedPeople.contains(person) ? brandBlue : Color(.systemGray4), lineWidth: 2)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .fill(brandBlue)
                                                .frame(width: 14, height: 14)
                                                .opacity(selectedPeople.contains(person) ? 1 : 0)
                                        )
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                            }
                            
                            if person != filteredPeople.last {
                                Divider()
                                    .padding(.leading, 78)
                            }
                        }
                    }
                }
                
                // Share button
                Button {
                    shareTrip()
                } label: {
                    Text("Share with \(selectedPeople.count) people")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selectedPeople.isEmpty ? Color(.systemGray4) : brandBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(selectedPeople.isEmpty)
                .padding(20)
            }
            .navigationTitle("Share Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .alert("Trip Shared!", isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("The trip link has been sent to \(selectedPeople.count) people. They can tap the link to view trip details.")
            }
        }
    }
    
    private func shareTrip() {
        // Generate a deep link for the trip
        let tripLink = "carpal://trip/\(tripId.uuidString)"
        
        // Send message to each selected person
        let messagesManager = MessagesManager.shared
        for person in selectedPeople {
            // Send a text message first
            let textMessage = Message(
                sender: "You",
                content: "Check out this trip: \(tripTitle)",
                timestamp: Date(),
                type: .text
            )
            messagesManager.sendMessage(textMessage, to: person)
            
            // Then send the link as a button
            let linkMessage = Message(
                sender: "You",
                content: "View Trip Details",
                timestamp: Date(),
                type: .link(tripLink)
            )
            messagesManager.sendMessage(linkMessage, to: person)
            
            print("Sent trip link to \(person): \(tripLink)")
        }
        
        showAlert = true
    }
}

// MARK: - Models

struct Comment: Identifiable {
    let id = UUID()
    let authorName: String
    let text: String
    let time: String
    let replies: [Reply]
}

struct Reply: Identifiable {
    let id = UUID()
    let authorName: String
    let text: String
    let time: String
}

#Preview {
    NavigationStack {
        TripDetailView(trip: SampleData.recommendedTrips[0])
    }
}
