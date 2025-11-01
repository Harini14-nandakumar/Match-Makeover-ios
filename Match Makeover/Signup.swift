//
//  Signup.swift
//  MatchMakeover
//
//  Created by SAIL01 on 05/06/25.
//

import SwiftUI

struct Signup: View {
    
    @State private var username: String = ""
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigation: Bool = false
    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss //  For navigation back
    
    var body: some View {
      
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack(spacing: 25) {
                        
                        CustomText(
                            text: "Signup to continue",
                            font: .title,
                            weight: .bold,
                            backgroundColor: .clear
                        )
                        
                        CustomTextField(placeholder: "name", text: $name)
                            .frame(width: 350)
                        CustomTextField(placeholder: "Username", text: $username)
                            .frame(width: 350)
                        CustomTextField(placeholder: "Password", text: $password)
                            .frame(width: 350)
                        CustomTextField(placeholder: "Email", text: $email)
                            .frame(width: 350)
                        
                        CustomButton(
                            title: "Signup",
                            action: {
                                signup() 
                            },
                            backgroundColor: .white,
                            foregroundColor: .black
                        )
                        .frame(width: geometry.size.width / 2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigation) {
                userview1()
            }
            .commonAlert(isPresented: $alert, title: "Alert", message: errorMessage)
        
    }
    
    func signup() {
        guard let name = name.isEmpty ? nil : name else{
            errorMessage = "Name is required."
            alert = true
            return
        }
        guard let username = username.isEmpty ? nil : username else{
            errorMessage = "Username is required."
            alert = true
            return
        }
        guard let password = password.isEmpty ? nil : password else {
            errorMessage = "Password is required."
            alert = true
            return
        }
        guard let email = email.isEmpty ? nil : email else{
            errorMessage = "Email is required."
            alert = true
            return
        }
        
        let user = SignupModel(name: name, username: username, password: password, email: email)
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            errorMessage = "Failed to encode signup data."
            alert = true
            return
        }
        
        APIHandler().postAPIRawJSON(
            type: SignupRes.self,
            apiUrl: ServiceAPI.signup, // Replace with your actual signup endpoint
            method: "POST",
            jsonData: jsonData
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Success:", response.message)
                    navigation = true
                case .failure(let error):
                    errorMessage = "Registration failed"
                }
            }
        }
    }
}


#Preview {
    Signup()
}
