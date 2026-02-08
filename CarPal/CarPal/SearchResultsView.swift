import SwiftUI

struct SearchResultsView: View {
    let results: [Trip]
    let fromLocation: String
    let toLocation: String
    let selectedTags: [String]
    
    @Environment(\.dismiss) private var dismiss
    
    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)
    private let tagGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Search summary
                searchSummary
                
                Divider()
                
                // Results
                if results.isEmpty {
                    emptyState
                } else {
                    resultsSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 80)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
    
    // MARK: - Search Summary
    
    private var searchSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(brandBlue)
                    .font(.system(size: 16))
                
                Text("Search Criteria")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Text("\(results.count) found")
                    .font(.system(size: 14))
                    .foregroundColor(brandBlue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if !fromLocation.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        Text("From:")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Text(fromLocation)
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                
                if !toLocation.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        Text("To:")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Text(toLocation)
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                
                if !selectedTags.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Filters:")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        FlowLayout(spacing: 6) {
                            ForEach(selectedTags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(brandBlue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(brandBlue.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // MARK: - Results Section
    
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Results")
                .font(.system(size: 16, weight: .semibold))
            
            ForEach(results) { trip in
                NavigationLink {
                    TripDetailView(trip: trip)
                } label: {
                    TripCard(trip: trip)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No trips found")
                .font(.system(size: 20, weight: .semibold))
            
            Text("Try adjusting your search criteria")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    NavigationStack {
        SearchResultsView(
            results: SampleData.recommendedTrips,
            fromLocation: "Haverford College",
            toLocation: "New York City",
            selectedTags: ["Pet Allow", "No Smoking"]
        )
    }
}
