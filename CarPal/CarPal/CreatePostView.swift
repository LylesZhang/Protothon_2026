import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var postsManager = MyPostsManager.shared
    
    @State private var title: String = ""
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var capacity: String = "3"
    @State private var departureDate: String = "Feb 10, 2026"
    @State private var departureTime: String = "9:00 AM"
    @State private var arrivalTime: String = "2:00 PM"
    @State private var description: String = ""
    @State private var tags: [String] = []
    @State private var newTag: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var tripImage: UIImage?
    @State private var hasOwnCar: Bool = true
    @State private var costType: Trip.CostType = .split
    @State private var estimatedCost: String = ""
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Hero image picker
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            ZStack {
                                if let tripImage = tripImage {
                                    Image(uiImage: tripImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                } else {
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(Color(.systemGray5))
                                        .frame(height: 200)
                                        .overlay(
                                            VStack(spacing: 8) {
                                                Image(systemName: "photo")
                                                    .font(.system(size: 40))
                                                    .foregroundStyle(Color(.systemGray2))
                                                Text("Tap to add photo")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                            }
                                        )
                                }
                            }
                        }
                        .onChange(of: selectedImage) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    tripImage = uiImage
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Trip Title")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                TextField("e.g., Weekend Getaway to Big Sur", text: $title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Origin
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Departure From")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                TextField("e.g., Haverford College", text: $origin)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Destination
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Destination")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                TextField("e.g., Philadelphia, PA", text: $destination)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Capacity
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Capacity (including you)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                TextField("e.g., 3", text: $capacity)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            // Date
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Trip Date")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                TextField("e.g., Feb 10, 2026", text: $departureDate)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Time Window
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Departure Time")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.gray)
                                    TextField("e.g., 9:00 AM", text: $departureTime)
                                }
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Arrival Time")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.gray)
                                    TextField("e.g., 2:00 PM", text: $arrivalTime)
                                }
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                TextEditor(text: $description)
                                    .frame(height: 120)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            // Requirements / Tags
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Requirements / Tags")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                // Display existing tags
                                if !tags.isEmpty {
                                    FlowLayout(spacing: 8) {
                                        ForEach(tags, id: \.self) { tag in
                                            HStack(spacing: 4) {
                                                Text(tag)
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundStyle(tagGreen)
                                                
                                                Button {
                                                    tags.removeAll { $0 == tag }
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 10, weight: .bold))
                                                        .foregroundStyle(tagGreen)
                                                }
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(tagGreen.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        }
                                    }
                                }
                                
                                // Add new tag
                                HStack {
                                    TextField("Add a tag (e.g. Music OK)", text: $newTag)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Button {
                                        if !newTag.isEmpty && !tags.contains(newTag) {
                                            tags.append(newTag)
                                            newTag = ""
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(brandBlue)
                                    }
                                    .disabled(newTag.isEmpty)
                                }
                                
                                Text("Add up to 5-10 tags for better matching.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            // Vehicle and Cost Information
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Transportation & Cost")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                // Vehicle toggle
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Do you have your own car?")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    HStack(spacing: 12) {
                                        Button {
                                            hasOwnCar = true
                                        } label: {
                                            HStack {
                                                Image(systemName: hasOwnCar ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(hasOwnCar ? brandBlue : .gray)
                                                Text("Yes, I'm driving")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.primary)
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(hasOwnCar ? brandBlue.opacity(0.1) : Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        
                                        Button {
                                            hasOwnCar = false
                                        } label: {
                                            HStack {
                                                Image(systemName: !hasOwnCar ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(!hasOwnCar ? brandBlue : .gray)
                                                Text("No, using rideshare")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.primary)
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(!hasOwnCar ? brandBlue.opacity(0.1) : Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                
                                // Cost type
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cost Arrangement")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    VStack(spacing: 8) {
                                        costTypeButton(.free, icon: "gift.fill", title: "Free Ride", subtitle: "No cost to participants")
                                        costTypeButton(.split, icon: "dollarsign.circle.fill", title: "Split Cost", subtitle: "Share gas/tolls/ride cost")
                                        costTypeButton(.paid, icon: "banknote.fill", title: "Paid Ride", subtitle: "Fixed price per person")
                                    }
                                }
                                
                                // Estimated cost (if not free)
                                if costType != .free {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Estimated Cost (Optional)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                        TextField("e.g., $20 per person", text: $estimatedCost)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
                .background(Color(.systemGroupedBackground))
                
                // Bottom Create Button
                VStack {
                    Spacer()
                    Button {
                        createPost()
                    } label: {
                        Text("Create Trip")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isFormValid ? brandBlue : Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle("Create Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !origin.isEmpty && !destination.isEmpty && !capacity.isEmpty
    }
    
    private func costTypeButton(_ type: Trip.CostType, icon: String, title: String, subtitle: String) -> some View {
        Button {
            costType = type
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(costType == type ? brandBlue : .gray)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: costType == type ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(costType == type ? brandBlue : .gray)
            }
            .padding(12)
            .background(costType == type ? brandBlue.opacity(0.08) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func createPost() {
        // Create new trip
        let newTrip = Trip(
            title: title,
            origin: origin,
            location: destination,
            setOff: departureTime,
            arrived: arrivalTime,
            tags: tags,
            author: "Lyles Zhang", // In real app, get from current user
            date: departureDate,
            imageName: "mountain", // Default image
            description: description.isEmpty ? "Looking forward to this trip!" : description,
            capacity: Int(capacity) ?? 3,
            currentParticipants: 1,
            hasOwnCar: hasOwnCar,
            costType: costType,
            estimatedCost: estimatedCost.isEmpty ? nil : estimatedCost
        )
        
        print("🆕 Creating new trip: \(newTrip.title)")
        print("🏷️ Tags: \(newTrip.tags)")
        
        // Add to My Posts
        postsManager.myPosts.insert(newTrip, at: 0)
        
        print("✅ Trip created and added to My Posts")
        
        // In a real app, also save to database (Supabase)
        dismiss()
    }
}

#Preview {
    CreatePostView()
}
