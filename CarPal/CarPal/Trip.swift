import Foundation

struct Trip: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let setOff: String
    let arrived: String
    let tags: [String]
    let author: String
    let date: String
    let imageName: String
}

enum SampleData {
    static let recommendedTrips: [Trip] = [
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
            title: "Coastal Highway Scenic Drive",
            location: "San Diego, CA",
            setOff: "6:30 AM",
            arrived: "10:00 AM",
            tags: ["Music OK", "Chat Welcome"],
            author: "Mike Johnson",
            date: "Feb 4, 2026",
            imageName: "coast"
        ),
        Trip(
            title: "Urban City Commute Tips",
            location: "Downtown LA",
            setOff: "7:00 AM",
            arrived: "8:15 AM",
            tags: ["No Smoking", "Quiet Ride"],
            author: "Amy Liu",
            date: "Feb 3, 2026",
            imageName: "city"
        ),
        Trip(
            title: "Desert Sunset Route",
            location: "Palm Springs, CA",
            setOff: "3:00 PM",
            arrived: "5:45 PM",
            tags: ["Pet Allow", "Music OK"],
            author: "Carlos Ruiz",
            date: "Feb 2, 2026",
            imageName: "desert"
        ),
    ]

    static let followingTrips: [Trip] = [
        Trip(
            title: "Philly Airport Express",
            location: "Philadelphia, PA",
            setOff: "5:00 AM",
            arrived: "5:45 AM",
            tags: ["Quiet Ride", "No Smoking"],
            author: "Oscar Tang",
            date: "Feb 6, 2026",
            imageName: "airport"
        ),
        Trip(
            title: "Weekend Walmart Run",
            location: "Cherry Hill, NJ",
            setOff: "10:00 AM",
            arrived: "10:30 AM",
            tags: ["Chat Welcome", "Pet Allow"],
            author: "Shaun Jin",
            date: "Feb 5, 2026",
            imageName: "shopping"
        ),
        Trip(
            title: "Downtown Food Tour Drive",
            location: "Washington, D.C.",
            setOff: "11:00 AM",
            arrived: "12:00 PM",
            tags: ["Music OK", "Chat Welcome", "Food Stops"],
            author: "Jose Andres",
            date: "Feb 4, 2026",
            imageName: "food"
        ),
        Trip(
            title: "Campus Carpool to UPenn",
            location: "University City, PA",
            setOff: "8:00 AM",
            arrived: "8:25 AM",
            tags: ["No Smoking", "Quiet Ride"],
            author: "Oscar Tang",
            date: "Feb 3, 2026",
            imageName: "campus"
        ),
        Trip(
            title: "Jersey Shore Day Trip",
            location: "Atlantic City, NJ",
            setOff: "9:00 AM",
            arrived: "10:30 AM",
            tags: ["Music OK", "Pet Allow"],
            author: "Shaun Jin",
            date: "Feb 1, 2026",
            imageName: "beach"
        ),
    ]

    static let lylesRecentDestinations = ["Walmart", "Philadelphia Intl Airport"]
}
