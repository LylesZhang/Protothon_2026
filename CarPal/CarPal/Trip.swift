import Foundation

struct Trip: Identifiable {
    let id: UUID
    var title: String
    var origin: String
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
    var currentParticipants: Int
    let likes: Int
    let tripDate: Date  // Actual trip date
    
    // Vehicle and cost info
    var hasOwnCar: Bool  // Whether the trip provider has their own car
    var costType: CostType  // Free, split, or paid
    var estimatedCost: String?  // Optional cost details (e.g., "$20 per person")
    
    enum CostType: String, Codable {
        case free = "Free Ride"
        case split = "Split Cost"
        case paid = "Paid Ride"
    }
    
    // Computed property to check if trip is finished
    var isFinished: Bool {
        return tripDate < Date()
    }
    
    init(id: UUID = UUID(), title: String, origin: String = "Haverford College", location: String, setOff: String, arrived: String, tags: [String], 
         author: String, date: String, imageName: String,
         authorPronoun: String = "they/them", authorRating: Double = 4.8, 
         authorCollege: String = "Haverford College", authorYear: String = "Junior", 
         authorGender: String = "Female", 
         description: String = "Looking forward to this trip!",
         capacity: Int = 3, currentParticipants: Int = 1,
         likes: Int = 0, tripDate: Date = Date(),
         hasOwnCar: Bool = true, costType: CostType = .split, estimatedCost: String? = nil) {
        self.id = id
        self.title = title
        self.origin = origin
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
        self.hasOwnCar = hasOwnCar
        self.costType = costType
        self.estimatedCost = estimatedCost
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
            title: "NYC Weekend Adventure",
            origin: "Haverford College",
            location: "New York City, NY",
            setOff: "8:00 AM - 9:00 AM",
            arrived: "10:30 AM - 11:30 AM",
            tags: ["Pet Allow", "Prefer Female", "No Smoking"],
            author: "Sarah Chen",
            date: "Feb 15, 2026",
            imageName: "city",
            authorPronoun: "she/her",
            authorRating: 4.8,
            authorCollege: "Bryn Mawr College",
            authorYear: "Junior",
            authorGender: "Female",
            description: "Planning a weekend trip to NYC this Saturday! Looking for someone to share the ride and split gas/tolls. I love listening to music and good conversation. My car has plenty of space for luggage. Perfect for museum visits or exploring the city!",
            capacity: 3,
            currentParticipants: 1,
            likes: 234,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15))!,
            hasOwnCar: true,
            costType: .split,
            estimatedCost: "$25 per person (gas + tolls)"
        ),
        Trip(
            id: coastTripId,
            title: "Jersey Shore Beach Day",
            origin: "Swarthmore College",
            location: "Ocean City, NJ",
            setOff: "9:00 AM - 9:30 AM",
            arrived: "11:30 AM - 12:00 PM",
            tags: ["Music OK", "Chat Welcome"],
            author: "Mike Johnson",
            date: "Feb 4, 2026",
            imageName: "beach",
            likes: 89,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 4))!,
            hasOwnCar: true,
            costType: .free
        ),
        Trip(
            id: cityTripId,
            title: "Philly Downtown Trip",
            origin: "Bryn Mawr College",
            location: "Center City Philadelphia",
            setOff: "2:00 PM - 2:15 PM",
            arrived: "2:45 PM - 3:00 PM",
            tags: ["No Smoking", "Quiet Ride"],
            author: "Amy Liu",
            date: "Feb 3, 2026",
            imageName: "city",
            likes: 156,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 3))!,
            hasOwnCar: false,
            costType: .split,
            estimatedCost: "$5 per person (Uber split)"
        ),
        Trip(
            id: desertTripId,
            title: "DC Museums Weekend",
            origin: "Haverford College",
            location: "Washington D.C.",
            setOff: "7:00 AM - 7:30 AM",
            arrived: "10:00 AM - 10:30 AM",
            tags: ["Pet Allow", "Music OK"],
            author: "Carlos Ruiz",
            date: "Feb 2, 2026",
            imageName: "city",
            likes: 201,
            tripDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 2))!,
            hasOwnCar: true,
            costType: .paid,
            estimatedCost: "$30 per person"
        ),
    ]

    static let followingTrips: [Trip] = [
        Trip(
            title: "PHL Airport Run",
            origin: "Haverford College",
            location: "Philadelphia Intl Airport",
            setOff: "5:00 AM",
            arrived: "5:35 AM",
            tags: ["Quiet Ride", "No Smoking"],
            author: "Oscar Tang",
            date: "Feb 6, 2026",
            imageName: "airport",
            hasOwnCar: true,
            costType: .split,
            estimatedCost: "$10 per person"
        ),
        Trip(
            title: "King of Prussia Mall Trip",
            origin: "Bryn Mawr College",
            location: "King of Prussia, PA",
            setOff: "1:00 PM",
            arrived: "1:25 PM",
            tags: ["Chat Welcome", "Music OK"],
            author: "Emma Wilson",
            date: "Feb 5, 2026",
            imageName: "shopping",
            hasOwnCar: true,
            costType: .free
        ),
        Trip(
            title: "Philly Food Tour",
            origin: "Swarthmore College",
            location: "Reading Terminal Market",
            setOff: "11:00 AM",
            arrived: "11:30 AM",
            tags: ["Music OK", "Chat Welcome", "Food Stops"],
            author: "Jordan Lee",
            date: "Feb 4, 2026",
            imageName: "food",
            hasOwnCar: false,
            costType: .split,
            estimatedCost: "$8 per person (Lyft)"
        ),
        Trip(
            title: "Tri-Co Campus Shuttle",
            origin: "Haverford College",
            location: "Swarthmore College",
            setOff: "9:00 AM",
            arrived: "9:25 AM",
            tags: ["No Smoking", "Quiet Ride"],
            author: "Alex Kim",
            date: "Feb 3, 2026",
            imageName: "campus",
            hasOwnCar: true,
            costType: .free
        ),
        Trip(
            title: "Target & Trader Joe's Run",
            origin: "Bryn Mawr College",
            location: "Ardmore, PA",
            setOff: "3:00 PM",
            arrived: "3:15 PM",
            tags: ["Music OK", "Chat Welcome"],
            author: "Maya Patel",
            date: "Feb 1, 2026",
            imageName: "shopping"
        ),
    ]

    static let lylesRecentDestinations = ["King of Prussia Mall", "Philadelphia Intl Airport"]
}
