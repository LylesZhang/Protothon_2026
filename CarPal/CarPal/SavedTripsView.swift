import SwiftUI

struct SavedTripsView: View {
    // In a real app, this would come from a data store
    @State private var savedTrips: [Trip] = []
    
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
        .onAppear {
            // Load saved trips from UserDefaults or a database
            // For demo, add some sample data after a moment
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // This would be replaced with actual saved trips
                // savedTrips = loadSavedTrips()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedTripsView()
    }
}
