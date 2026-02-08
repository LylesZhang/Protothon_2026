import SwiftUI

struct SavedTripsView: View {
    @StateObject private var savedTripsManager = SavedTripsManager.shared
    @StateObject private var tripsManager = TripsManager.shared
    
    private var savedTrips: [Trip] {
        return savedTripsManager.getSavedTrips()
    }
    
    var body: some View {
        Group {
            if savedTrips.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Saved Trips")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("Trips you save will appear here")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(savedTrips) { trip in
                            NavigationLink {
                                TripDetailView(trip: trip)
                            } label: {
                                TripCard(trip: trip)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 80)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle("Saved Trips")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SavedTripsView()
    }
}
