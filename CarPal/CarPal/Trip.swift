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
    
    // Extended fields for detail view
    let authorPronoun: String
    let authorRating: Double
    let authorCollege: String
    let authorYear: String
    let authorGender: String
    let description: String
    let capacity: Int
    let currentParticipants: Int
    
    init(title: String, location: String, setOff: String, arrived: String, tags: [String], 
         author: String, date: String, imageName: String,
         authorPronoun: String = "they/them", authorRating: Double = 4.8, 
         authorCollege: String = "UCLA", authorYear: String = "Junior", 
         authorGender: String = "Female", 
         description: String = "Looking forward to this trip!",
         capacity: Int = 3, currentParticipants: Int = 1) {
        self.title = title
        self.location = location
        self.setOff = setOff
        self.arrived = arrived
        self.tags = tags
        self.author = author
        self.date = date
        self.imageName = imageName
        self.authorPronoun = authorPronoun
        self.authorRating = authorRating
        self.authorCollege = authorCollege
        self.authorYear = authorYear
        self.authorGender = authorGender
        self.description = description
        self.capacity = capacity
        self.currentParticipants = currentParticipants
    }
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
            imageName: "mountain",
            authorPronoun: "she/her",
            authorRating: 4.8,
            authorCollege: "UCLA",
            authorYear: "Junior",
            authorGender: "Female",
            description: "Planning a scenic drive to Lake Tahoe this weekend! Looking for someone to share the ride and split gas costs. I love listening to music and good conversation. My car has plenty of space for luggage. Let me know if you are interested!",
            capacity: 3,
            currentParticipants: 1
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
