import SwiftUI

struct HomeView: View {
    let username: String

    @State private var selectedTab = 0
    @State private var showFilter = false
    @StateObject private var tripsManager = TripsManager.shared

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tabs = ["Recommended", "Following"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Search bar
                    searchBar

                    // Tabs
                    tabSelector

                    // Recently Searched Destinations
                    if selectedTab == 0 {
                        recentDestinations
                    }

                    // Trip cards - use TripsManager for real-time updates
                    let recommendedTrips = tripsManager.allTrips.prefix(4)
                    let followingTrips = tripsManager.allTrips.suffix(tripsManager.allTrips.count - 4)
                    
                    let trips = selectedTab == 0
                        ? Array(recommendedTrips)
                        : Array(followingTrips)

                    ForEach(trips) { trip in
                        NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            TripCard(trip: trip)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
            }

            Spacer(minLength: 0)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showFilter) {
            SearchFilterView()
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        Button {
            showFilter = true
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Find your ride")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(14)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 8)
    }

    // MARK: - Tab Selector

    private var tabSelector: some View {
        HStack(spacing: 24) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 6) {
                        Text(tab)
                            .font(.system(size: 17, weight: selectedTab == index ? .bold : .regular))
                            .foregroundColor(selectedTab == index ? .primary : .gray)

                        Rectangle()
                            .fill(selectedTab == index ? brandBlue : .clear)
                            .frame(height: 2.5)
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 4)
    }

    // MARK: - Recent Destinations

    private var recentDestinations: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recently Searched Destinations")
                .font(.system(size: 15))
                .foregroundColor(.gray)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SampleData.lylesRecentDestinations, id: \.self) { dest in
                        Text(dest)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Trip Card

struct TripCard: View {
    let trip: Trip

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
                    Text(trip.title)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)

                    Label(trip.location, systemImage: "mappin")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Label("Set off: \(trip.setOff)", systemImage: "clock")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Label("Arrived: \(trip.arrived)", systemImage: "clock.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    // Tags
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

            // Author & date & likes
            HStack {
                Text("\(trip.author)  ·  \(trip.date)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 12))
                    Text("\(trip.likes)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
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

// MARK: - Flow Layout for Tags

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = result.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}

#Preview {
    HomeView(username: "Lyles")
}
