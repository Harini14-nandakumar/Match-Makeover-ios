//
//  Login.swift
//  MatchMakeover
//
//  Created by SAIL01 on 04/06/25.
//
import SwiftUI



struct LoginView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var navigation:Bool = false
    
    var body: some View {
        GeometryReader { geometry in   // BaseView for dynamic height and width
            NavigationStack {   // Base view for navigation
                VStack(spacing:25) { // FisrtVstack
                   
                    
                    CustomImage(name: "Image")
                   
                    
                    CustomTextField(placeholder: "Username", text: $email)
                    CustomTextField(placeholder: "Password", text: $password)
                    
                    CustomButton(title: "Login", action: {
                        print("hi")
                    },backgroundColor: .gray,foregroundColor: .black)
                    .frame(width: geometry.size.width / 2)
                    
                
                    
                    CustomButton(title: "SignUp", action: {
                        print("hi")
                    },backgroundColor: .clear,foregroundColor: .blue)
                    .frame(width: geometry.size.width / 2)
                    
                }
                .padding()
                
                
                
            }
           
            
        }
        
    }
}

#Preview {
    LoginView()
}


