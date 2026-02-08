import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Settings page")
                .font(.system(size: 18))
                .foregroundColor(.gray)
            Text("For showcase purposes only")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray3))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
