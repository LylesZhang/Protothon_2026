import SwiftUI

struct MyPostsView: View {
    let username: String

    @State private var myPosts: [Trip] = [
        Trip(
            title: "Mountain Road Trip Adventure",
            location: "Lake Tahoe, CA",
            setOff: "8:00 AM",
            arrived: "12:30 PM",
            tags: ["Pet Allow", "Prefer Female", "No Smoking"],
            author: "Sarah Chen",
            date: "Feb 5, 2026",
            imageName: "mountain"
        ),
        Trip(
            title: "Forest Road Nature Escape",
            location: "Big Sur, CA",
            setOff: "9:00 AM",
            arrived: "2:30 PM",
            tags: ["Pet Allow", "Music OK", "Luggage Space"],
            author: "Sarah Chen",
            date: "Feb 2, 2026",
            imageName: "forest"
        ),
    ]

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(myPosts) { trip in
                    MyPostCard(trip: trip, brandBlue: brandBlue) {
                        // Delete action
                        withAnimation {
                            myPosts.removeAll { $0.id == trip.id }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Posts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - My Post Card (with edit/delete)

struct MyPostCard: View {
    let trip: Trip
    let brandBlue: Color
    let onDelete: () -> Void

    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)

    private var symbolName: String {
        switch trip.imageName {
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
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Thumbnail
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: symbolName)
                            .font(.system(size: 28))
                            .foregroundStyle(Color(.systemGray2))
                    )

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Text(trip.title)
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(2)

                        Spacer()

                        // Edit button
                        Button {
                            // TODO: edit post
                        } label: {
                            Image(systemName: "pencil.circle")
                                .font(.system(size: 22))
                                .foregroundColor(brandBlue)
                        }

                        // Delete button
                        Button {
                            onDelete()
                        } label: {
                            Image(systemName: "trash.circle")
                                .font(.system(size: 22))
                                .foregroundColor(.red)
                        }
                    }

                    Label(trip.location, systemImage: "mappin")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Label("Set off: \(trip.setOff)", systemImage: "clock")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Label("Arrived: \(trip.arrived)", systemImage: "clock.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    FlowLayout(spacing: 6) {
                        ForEach(trip.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(tagGreen)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(tagGreen.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(14)

            Divider()

            HStack {
                Text("\(trip.author)  ·  \(trip.date)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray4), lineWidth: 0.8)
        )
    }
}

#Preview {
    NavigationStack {
        MyPostsView(username: "Lyles")
    }
}
