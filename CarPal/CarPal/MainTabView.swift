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
                    ProfilePlaceholderView(username: username)
                default:
                    HomeView(username: username)
                }
            }

            // Custom Tab Bar
            tabBar
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddTrip) {
            AddTripPlaceholderView()
        }
    }

    private var tabBar: some View {
        HStack {
            // Home tab
            Spacer()
            Button {
                selectedTab = 0
            } label: {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    .font(.system(size: 22))
                    .foregroundStyle(selectedTab == 0 ? brandBlue : .gray)
            }

            Spacer()

            // Add button (center)
            Button {
                showAddTrip = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(brandBlue)
                    .clipShape(Circle())
                    .shadow(color: brandBlue.opacity(0.3), radius: 6, y: 3)
            }
            .offset(y: -12)

            Spacer()

            // Profile tab
            Button {
                selectedTab = 2
            } label: {
                Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    .font(.system(size: 22))
                    .foregroundStyle(selectedTab == 2 ? brandBlue : .gray)
            }

            Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
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
