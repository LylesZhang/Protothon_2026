import SwiftUI
import PhotosUI

struct EditPostView: View {
    @Environment(\.dismiss) private var dismiss
    
    let trip: Trip
    @State private var title: String
    @State private var origin: String
    @State private var destination: String
    @State private var capacity: String
    @State private var departureWindow: String
    @State private var arrivalWindow: String
    @State private var description: String
    @State private var tags: [String]
    @State private var newTag: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var tripImage: UIImage?
    
    let onSave: (Trip) -> Void
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    init(trip: Trip, onSave: @escaping (Trip) -> Void = { _ in }) {
        self.trip = trip
        self.onSave = onSave
        _title = State(initialValue: trip.title)
        _origin = State(initialValue: trip.origin)
        _destination = State(initialValue: trip.location)
        _capacity = State(initialValue: String(trip.capacity))
        _departureWindow = State(initialValue: trip.setOff)
        _arrivalWindow = State(initialValue: trip.arrived)
        _description = State(initialValue: trip.description)
        _tags = State(initialValue: trip.tags)
    }
    
    var body: some View {
        NavigationStack {
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
                                                .foregroundColor(.gray)
                                            Text("Tap to select image")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                        }
                    }
                    .onChange(of: selectedImage) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                tripImage = image
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Trip Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trip Title")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            TextField("Mountain Road Trip Adventure", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Origin
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Departure From")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "location")
                                    .foregroundColor(.gray)
                                TextField("UCLA", text: $origin)
                            }
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        HStack(spacing: 12) {
                            // Destination
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Destination")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "mappin")
                                        .foregroundColor(.gray)
                                    TextField("Lake Tahoe, CA", text: $destination)
                                }
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            // Capacity
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Capacity")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack {
                                    TextField("3", text: $capacity)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                    Text("People max")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                        HStack(spacing: 12) {
                            // Departure Window
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Departure Window")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.gray)
                                    TextField("8:00 AM - 9:00 AM", text: $departureWindow)
                                        .font(.system(size: 14))
                                }
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            // Arrival Window
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Arrival Window")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.gray)
                                    TextField("12:30 PM - 1:30 PM", text: $arrivalWindow)
                                        .font(.system(size: 14))
                                }
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
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
                            FlowLayout(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
                                    HStack(spacing: 4) {
                                        Text(tag)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.blue)
                                        
                                        Button {
                                            tags.removeAll { $0 == tag }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Edit Post")
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
            .safeAreaInset(edge: .bottom) {
                // Save Changes button
                Button {
                    saveChanges()
                } label: {
                    Text("Save Changes")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(brandBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
        }
    }
    
    private func saveChanges() {
        // Update trip with new values
        var updatedTrip = trip
        updatedTrip.title = title
        updatedTrip.origin = origin
        updatedTrip.location = destination
        updatedTrip.capacity = Int(capacity) ?? trip.capacity
        updatedTrip.setOff = departureWindow
        updatedTrip.arrived = arrivalWindow
        updatedTrip.description = description
        updatedTrip.tags = tags
        
        // Debug: Print tags before saving
        print("🏷️ Saving tags: \(tags)")
        print("📝 Updated trip tags: \(updatedTrip.tags)")
        
        // Call the callback to save changes
        onSave(updatedTrip)
        
        // In a real app, also save to database (Supabase)
        dismiss()
    }
}

#Preview {
    EditPostView(trip: SampleData.recommendedTrips[0])
}
