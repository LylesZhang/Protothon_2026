import SwiftUI

struct MainTabView: View {
    let username: String

    @State private var selectedTab = 0
    @State private var showAddTrip = false

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                switch selectedTab {
                case 0:
                    HomeView(username: username)
                case 2:
                    ProfileView(username: username)
                default:
                    HomeView(username: username)
                }
            }

            // Custom Tab Bar
            tabBar
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddTrip) {
            CreatePostView()
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            // Home tab
            Button {
                selectedTab = 0
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 0 ? brandBlue : .gray)
                        .frame(height: 24)
                }
                .frame(maxWidth: .infinity)
            }

            // Add button (center)
            Button {
                showAddTrip = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(brandBlue)
                    .clipShape(Circle())
                    .shadow(color: brandBlue.opacity(0.3), radius: 8, y: 3)
            }
            .offset(y: -8)
            .frame(maxWidth: .infinity)

            // Profile tab
            Button {
                selectedTab = 2
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 2 ? brandBlue : .gray)
                        .frame(height: 24)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 22)
        .background(
            Rectangle()
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: -2)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Placeholder Views

struct ProfilePlaceholderView: View {
    let username: String
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(brandBlue)
            Text(username)
                .font(.system(size: 24, weight: .bold))
            Text("Profile page coming soon")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct AddTripPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(brandBlue)
                Text("Post a new trip")
                    .font(.system(size: 20, weight: .semibold))
                Text("Coming soon")
                    .foregroundColor(.gray)
                Spacer()
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    MainTabView(username: "Lyles")
}
