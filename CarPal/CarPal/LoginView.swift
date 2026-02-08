import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var loginSuccess = false
    @State private var showError = false

    private let brandBlue = Color(red: 0.231, green: 0.357, blue: 0.906)

    // Test user
    private let testUsername = "Lyles"
    private let testPassword = "Zhangzhiyuan123"

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Welcome Back")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(brandBlue)

            VStack(spacing: 16) {
                TextField("Email or Username", text: $username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                SecureField("Password", text: $password)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)

            Button {
                if username.lowercased() == testUsername.lowercased() && password == testPassword {
                    loginSuccess = true
                } else {
                    showError = true
                }
            } label: {
                Text("Log In")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(brandBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)
            .alert("Login Failed", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Invalid username or password.")
            }

            Spacer()
            Spacer()
        }
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $loginSuccess) {
            MainTabView(username: username)
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
