import SwiftUI

struct HistoryView: View {
    private let historyTrips: [Trip] = [
        Trip(
            id: SampleData.mountainTripId,
            title: "Mountain Road Trip Adventure",
            location: "Lake Tahoe, CA",
            setOff: "8:00 AM - 9:00 AM",
            arrived: "12:30 PM - 1:30 PM",
            tags: ["Pet Allow", "Prefer Female", "No Smoking"],
            author: "Sarah Chen",
            date: "Feb 15, 2026",
            imageName: "mountain",
            authorPronoun: "she/her",
            authorRating: 4.8,
            authorCollege: "UCLA",
            authorYear: "Junior",
            authorGender: "Female",
            description: "Planning a scenic drive to Lake Tahoe this weekend! Looking for someone to share the ride and split gas costs. I love listening to music and good conversation. My car has plenty of space for luggage. Let me know if you are interested!",
            capacity: 3,
            currentParticipants: 1,
            likes: 234,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15))!
        ),
        Trip(
            id: SampleData.cityTripId,
            title: "Urban City Commute Tips",
            location: "Downtown LA",
            setOff: "7:00 AM - 7:15 AM",
            arrived: "8:15 AM - 8:30 AM",
            tags: ["No Smoking", "Quiet Ride"],
            author: "Amy Liu",
            date: "Feb 3, 2026",
            imageName: "city",
            likes: 156,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 3))!
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(historyTrips) { trip in
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
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
