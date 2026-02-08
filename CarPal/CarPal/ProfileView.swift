import SwiftUI
import UIKit

struct ProfileView: View {
    let username: String

    @State private var showAvatarModal = false

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Top section: Avatar + Stats
                    profileHeader

                    // Menu items
                    VStack(spacing: 12) {
                        ProfileMenuItem(
                            title: "History",
                            subtitle: "All trips you've participated in",
                            destination: HistoryView()
                        )
                        ProfileMenuItem(
                            title: "Saved Trips",
                            subtitle: "Trips you've saved for later",
                            destination: SavedTripsView()
                        )
                        ProfileMenuItem(
                            title: "Messages",
                            subtitle: "Messages, group chats, and chatbot",
                            destination: MessagesView()
                        )
                        ProfileMenuItem(
                            title: "My Posts",
                            subtitle: "Posts you've created",
                            destination: MyPostsView(username: username)
                        )
                        ProfileMenuItem(
                            title: "Settings",
                            subtitle: "App preferences and account",
                            destination: SettingsView()
                        )
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
            .background(Color(.systemGroupedBackground))
            .fullScreenCover(isPresented: $showAvatarModal) {
                AvatarModalView()
            }
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        HStack(alignment: .top, spacing: 16) {
            // Avatar + Rating
            VStack(spacing: 8) {
                Button {
                    showAvatarModal = true
                } label: {
                    AvatarImage(size: 90)
                }

                Text("Rating")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < 4 ? "star.fill" : "star")
                            .font(.system(size: 14))
                            .foregroundColor(i < 4 ? .yellow : Color(.systemGray4))
                    }
                    Text("4.8")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.leading, 2)
                }
            }

            // Stats grid
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    StatBox(value: "1234", label: "Likes Received")
                    StatBox(value: "45", label: "Posts")
                }
                HStack(spacing: 10) {
                    StatBox(value: "892", label: "Followers")
                    StatBox(value: "156", label: "Following")
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Avatar Image (reusable)

struct AvatarImage: View {
    let size: CGFloat

    var body: some View {
        Group {
            if let uiImage = UIImage(named: "avatar") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Circle().fill(Color(.systemGray5))
                    Image(systemName: "person.fill")
                        .font(.system(size: size * 0.42, weight: .semibold))
                        .foregroundColor(Color(.systemGray2))
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 0.5))
    }
}

// MARK: - Stat Box

struct StatBox: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Profile Menu Item

struct ProfileMenuItem<Destination: View>: View {
    let title: String
    let subtitle: String
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(.systemGray4), lineWidth: 0.8)
            )
        }
    }
}

// MARK: - Avatar Modal

struct AvatarModalView: View {
    @Environment(\.dismiss) private var dismiss
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                AvatarImage(size: 240)

                Spacer()

                Button {
                    // TODO: photo picker
                } label: {
                    Text("Upload New Profile Photo")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(brandBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }

            // Close button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(20)
        }
    }
}

#Preview {
    ProfileView(username: "Lyles")
}
