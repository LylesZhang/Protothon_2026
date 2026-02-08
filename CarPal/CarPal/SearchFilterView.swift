import SwiftUI

struct SearchFilterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var departureDate = Date()
    @State private var showDatePicker = false
    @State private var selectedTags: Set<String> = []
    @State private var customTagText = ""
    @State private var customTags: [String] = []
    @State private var showSearchResults = false
    @State private var searchResults: [Trip] = []

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    private let presetTags = [
        "Pet Allow",
        "No Smoking",
        "Prefer Female",
        "Prefer Male",
        "Chat Welcome",
        "Quiet Ride",
        "Music OK",
        "Luggage OK",
        "Carpool",
        "Paid Ride",
        "Free Ride",
        "Food Stops",
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - From / To
                    fromToSection

                    Divider()

                    // MARK: - Departure Date
                    dateSection

                    Divider()

                    // MARK: - Tags
                    tagsSection

                    Divider()

                    // MARK: - Custom Tag
                    customTagSection

                    // MARK: - Search Button
                    Button {
                        performSearch()
                    } label: {
                        Text("Search")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(brandBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Find Your Ride")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showSearchResults) {
                SearchResultsView(
                    results: searchResults,
                    fromLocation: fromLocation,
                    toLocation: toLocation,
                    selectedTags: Array(selectedTags)
                )
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        fromLocation = ""
                        toLocation = ""
                        departureDate = Date()
                        showDatePicker = false
                        selectedTags.removeAll()
                        customTags.removeAll()
                        customTagText = ""
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }

    // MARK: - From / To

    private var fromToSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Route")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .textCase(.uppercase)

            // From
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("From")
                        .font(.system(size: 15, weight: .semibold))
                    Circle()
                        .fill(.red)
                        .frame(width: 6, height: 6)
                }

                HStack {
                    TextField("Leaving from", text: $fromLocation)
                        .autocorrectionDisabled()
                    Image(systemName: "location.north.fill")
                        .foregroundStyle(brandBlue)
                        .font(.system(size: 14))
                }
                .padding(12)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }

            // Swap button
            HStack {
                Spacer()
                Button {
                    let temp = fromLocation
                    fromLocation = toLocation
                    toLocation = temp
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(brandBlue)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                Spacer()
            }

            // To
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("To")
                        .font(.system(size: 15, weight: .semibold))
                    Circle()
                        .fill(.red)
                        .frame(width: 6, height: 6)
                }

                TextField("Going to", text: $toLocation)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            }
        }
    }

    // MARK: - Date

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("Depart")
                        .font(.system(size: 15, weight: .semibold))
                    Circle()
                        .fill(.red)
                        .frame(width: 6, height: 6)
                }

                Button {
                    withAnimation { showDatePicker.toggle() }
                } label: {
                    HStack {
                        Text(showDatePicker
                             ? departureDate.formatted(date: .abbreviated, time: .shortened)
                             : "Select date & time")
                            .foregroundColor(showDatePicker ? .primary : .gray)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundStyle(brandBlue)
                    }
                    .padding(12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
            }

            if showDatePicker {
                DatePicker(
                    "Departure",
                    selection: $departureDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding(8)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Tags

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .textCase(.uppercase)

            FlowLayout(spacing: 8) {
                ForEach(presetTags + customTags, id: \.self) { tag in
                    TagChip(
                        label: tag,
                        isSelected: selectedTags.contains(tag),
                        isCustom: customTags.contains(tag),
                        brandBlue: brandBlue
                    ) {
                        if selectedTags.contains(tag) {
                            selectedTags.remove(tag)
                        } else {
                            selectedTags.insert(tag)
                        }
                    } onDelete: {
                        customTags.removeAll { $0 == tag }
                        selectedTags.remove(tag)
                    }
                }
            }
        }
    }

    // MARK: - Custom Tag Input

    private var customTagSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add Custom Tag")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .textCase(.uppercase)

            HStack(spacing: 10) {
                TextField("e.g. EV Friendly", text: $customTagText)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

                Button {
                    let trimmed = customTagText.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    if !presetTags.contains(trimmed) && !customTags.contains(trimmed) {
                        customTags.append(trimmed)
                        selectedTags.insert(trimmed)
                    }
                    customTagText = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(brandBlue)
                }
            }
        }
    }
    
    // MARK: - Search Logic
    
    private func performSearch() {
        let allTrips = TripsManager.shared.allTrips
        
        searchResults = allTrips.filter { trip in
            var matches = true
            
            // Filter by origin (from location)
            if !fromLocation.isEmpty {
                matches = matches && trip.origin.localizedCaseInsensitiveContains(fromLocation)
            }
            
            // Filter by destination (to location)
            if !toLocation.isEmpty {
                matches = matches && trip.location.localizedCaseInsensitiveContains(toLocation)
            }
            
            // Filter by tags
            if !selectedTags.isEmpty {
                let tripTags = Set(trip.tags)
                // Check if trip has at least one of the selected tags
                matches = matches && !selectedTags.isDisjoint(with: tripTags)
            }
            
            // Filter by date (optional - currently not filtering by exact date)
            // Could add date filtering logic here if needed
            
            return matches
        }
        
        showSearchResults = true
    }
}

// MARK: - Tag Chip

struct TagChip: View {
    let label: String
    let isSelected: Bool
    let isCustom: Bool
    let brandBlue: Color
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 13, weight: .medium))

                if isCustom {
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundColor(isSelected ? .white : .primary)
            .background(isSelected ? brandBlue : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? brandBlue : Color(.systemGray4), lineWidth: 0.8)
            )
        }
    }
}

#Preview {
    SearchFilterView()
}
