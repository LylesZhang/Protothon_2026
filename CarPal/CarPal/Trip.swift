import Foundation

struct Trip: Identifiable {
    let id: UUID
    var title: String
    var location: String
    var setOff: String
    var arrived: String
    var tags: [String]
    let author: String
    let date: String
    var imageName: String
    
    // Extended fields for detail view
    let authorPronoun: String
    let authorRating: Double
    let authorCollege: String
    let authorYear: String
    let authorGender: String
    var description: String
    var capacity: Int
    let currentParticipants: Int
    let likes: Int
    let tripDate: Date  // Actual trip date
    
    // Computed property to check if trip is finished
    var isFinished: Bool {
        return tripDate < Date()
    }
    
    init(id: UUID = UUID(), title: String, location: String, setOff: String, arrived: String, tags: [String], 
         author: String, date: String, imageName: String,
         authorPronoun: String = "they/them", authorRating: Double = 4.8, 
         authorCollege: String = "UCLA", authorYear: String = "Junior", 
         authorGender: String = "Female", 
         description: String = "Looking forward to this trip!",
         capacity: Int = 3, currentParticipants: Int = 1,
         likes: Int = 0, tripDate: Date = Date()) {
        self.id = id
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
        self.likes = likes
        self.tripDate = tripDate
    }
}

enum SampleData {
    // Fixed IDs for consistent trip identification
    static let mountainTripId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let coastTripId = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    static let cityTripId = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    static let desertTripId = UUID(uuidString: "44444444-4444-4444-4444-444444444444")!
    
    static let recommendedTrips: [Trip] = [
        Trip(
            id: mountainTripId,
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
            id: coastTripId,
            title: "Coastal Highway Scenic Drive",
            location: "San Diego, CA",
            setOff: "6:30 AM - 7:00 AM",
            arrived: "10:00 AM - 10:30 AM",
            tags: ["Music OK", "Chat Welcome"],
            author: "Mike Johnson",
            date: "Feb 4, 2026",
            imageName: "coast",
            likes: 89,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 4))!
        ),
        Trip(
            id: cityTripId,
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
        Trip(
            id: desertTripId,
            title: "Desert Sunset Route",
            location: "Palm Springs, CA",
            setOff: "3:00 PM - 3:30 PM",
            arrived: "5:45 PM - 6:15 PM",
            tags: ["Pet Allow", "Music OK"],
            author: "Carlos Ruiz",
            date: "Feb 2, 2026",
            imageName: "desert",
            likes: 201,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 2))!
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
