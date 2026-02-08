import SwiftUI

struct HistoryView: View {
    private let historyTrips: [Trip] = [
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
            title: "Urban City Commute Tips",
            location: "Downtown LA",
            setOff: "7:15 AM",
            arrived: "8:00 AM",
            tags: ["Prefer Male", "Quiet Ride", "No Smoking"],
            author: "Alex Rivera",
            date: "Feb 3, 2026",
            imageName: "city"
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(historyTrips) { trip in
                    TripCard(trip: trip)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
