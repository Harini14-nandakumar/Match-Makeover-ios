//
//  Signup.swift
//  MatchMakeover
//
//  Created by SAIL01 on 05/06/25.
//

import SwiftUI



struct Signup: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var navigation:Bool = false
    
    var body: some View {
        GeometryReader { geometry in   // BaseView for dynamic height and width
          
            VStack(spacing:25) {
                
                CustomTextField(placeholder: "name", text: $email)
                CustomTextField(placeholder: "Username", text: $email)
                CustomTextField(placeholder: "Password", text: $password)
                CustomTextField(placeholder: "Email", text: $email)
                
                
                
            }
                .padding()
                
                
                
            }
           
            
        }
        
    
}

#Preview {
    Signup()
}


