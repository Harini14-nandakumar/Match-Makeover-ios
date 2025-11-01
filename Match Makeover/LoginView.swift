//
//  Login.swift
//  MatchMakeover
//
//  Created by SAIL01 on 04/06/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var navigateToAdmin: Bool = false
    @State private var navigateToSignup: Bool = false
    @State private var navigation: Bool = false  // For userview
    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer(minLength: 40)

                        VStack(spacing: 30) {
                            CustomImage(name: "icon")
                            
                            CustomTextField(placeholder: "Username", text: $username)
                                .frame(width: 350)
                            
                            CustomTextField(placeholder: "Password", text: $password)
                                .frame(width: 350)
                            
                            // Login Button
                            CustomButton(title: "Login", action: {
                                loginUser()
                            }, backgroundColor: .white, foregroundColor: .black)
                            .frame(width: geometry.size.width / 2)
                            
                            // Sign Up Button
                            CustomButton(title: "SignUp", action: {
                                navigateToSignup = true
                            }, backgroundColor: .clear, foregroundColor: .blue)
                            .frame(width: geometry.size.width / 2)
                        }
                        .padding()
                        .background(Color.white.opacity(0.001)) // Optional: avoid content transparency issues

                        Spacer(minLength: 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures VStack fills the space
                }
                .navigationDestination(isPresented: $navigateToAdmin) {
                    Adminview()
                }
                .navigationDestination(isPresented: $navigation) {
                    userview1()
                }
                .navigationDestination(isPresented: $navigateToSignup) {
                    Signup()
                }
                .commonAlert(isPresented: $alert, title: "Alert", message: errorMessage)
            }
        
    }

    func loginUser() {
        guard let username = username.isEmpty ? nil : username else {
            alert = true
            errorMessage = "Username is required."
            return
        }
        guard let password = password.isEmpty ? nil : password else {
            alert = true
            errorMessage = "Password is required."
            return
        }

        let user = LoginRes(username: username, password: password)

        guard let jsonData = try? JSONEncoder().encode(user) else {
            errorMessage = "Failed to encode request."
            alert = true
            return
        }

        APIHandler().postAPIRawJSON(
            type: LoginModel.self,
            apiUrl: ServiceAPI.login,
            method: "POST",
            jsonData: jsonData
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Success:", response.message)
                    
                    if response.role.lowercased() == "admin" {
                        navigateToAdmin = true
                    } else if response.role.lowercased() == "user" {
                        navigation = true
                    } else {
                        errorMessage = "Unknown role: \(response.role)"
                        alert = true
                    }
                case .failure(_):
                    errorMessage = "Login failed. Please try again."
                    alert = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
