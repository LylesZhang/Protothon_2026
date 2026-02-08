import SwiftUI

struct LandingView: View {
    @State private var showLogin = false
    @State private var showSignUp = false

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                // Brand name
                Text("CarPal")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(brandBlue)

                // Tagline
                Text("Ride with a pal, not a stranger")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.top, 8)

                Spacer()
                    .frame(height: 80)

                // Buttons
                VStack(spacing: 16) {
                    // Log In button - filled blue
                    Button {
                        showLogin = true
                    } label: {
                        Text("Log In")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(brandBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    // Sign In button - outlined
                    Button {
                        showSignUp = true
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(brandBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(.systemGray4), lineWidth: 1.5)
                            )
                    }
                }
                .padding(.horizontal, 32)

                Spacer()
                Spacer()
            }
            .background(.white)
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

#Preview {
    LandingView()
}
