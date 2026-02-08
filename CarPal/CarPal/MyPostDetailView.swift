import SwiftUI

struct MyPostDetailView: View {
    let tripId: UUID
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var savedTripsManager = SavedTripsManager.shared
    @StateObject private var postsManager = MyPostsManager.shared
    @State private var showComments = false
    @State private var showShareSheet = false
    @State private var showEditPost = false
    
    init(trip: Trip) {
        self.tripId = trip.id
    }
    
    private var trip: Trip? {
        postsManager.getPost(by: tripId)
    }
    
    private var isSaved: Bool {
        savedTripsManager.isSaved(tripId: tripId)
    }
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    // Map image names to SF Symbols
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
    
    var body: some View {
        Group {
            if let trip = trip {
                contentView(for: trip)
            } else {
                Text("Post not found")
                    .foregroundColor(.gray)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditPost = true
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(brandBlue)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $showComments) {
            if let trip = trip {
                CommentsView(tripTitle: trip.title)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let trip = trip {
                SharePostView(tripTitle: trip.title, tripId: trip.id)
            }
        }
        .sheet(isPresented: $showEditPost) {
            if let trip = trip {
                EditPostView(trip: trip) { updatedTrip in
                    postsManager.updatePost(updatedTrip)
                }
            }
        }
    }
    
    @ViewBuilder
    private func contentView(for trip: Trip) -> some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Image
                    heroImage(for: trip)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        Text(trip.title)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.top, 20)
                        
                        // Poster Detail
                        posterSection(for: trip)
                        
                        Divider()
                        
                        // Trip Detail
                        tripDetailSection(for: trip)
                        
                        Divider()
                        
                        // Description
                        descriptionSection(for: trip)
                        
                        Divider()
                        
                        // Requirements
                        requirementsSection(for: trip)
                        
                        Divider()
                        
                        // Status
                        statusSection(for: trip)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            
            // Toolbar at bottom (only Comment, Save, Share)
            VStack {
                Spacer()
                myPostToolbar(for: trip)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    // MARK: - Hero Image
    
    private func heroImage(for trip: Trip) -> some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color(.systemGray5))
            .frame(height: 240)
            .overlay(
                Image(systemName: symbolName(for: trip.imageName))
                    .font(.system(size: 60))
                    .foregroundStyle(Color(.systemGray2))
            )
    }
    
    // MARK: - Poster Section (same as TripDetailView)
    
    private func posterSection(for trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Poster")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
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
    
    private func tripDetailSection(for trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trip Details")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
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
    
    private func descriptionSection(for trip: Trip) -> some View {
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
    
    private func requirementsSection(for trip: Trip) -> some View {
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
    
    private func statusSection(for trip: Trip) -> some View {
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
                Text("\(trip.likes) likes")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - My Post Toolbar (only Comment, Save, Share)
    
    private func myPostToolbar(for trip: Trip) -> some View {
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
            
            // Save (instead of Like for own posts)
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
}

#Preview {
    NavigationStack {
        MyPostDetailView(trip: SampleData.recommendedTrips[0])
    }
}
