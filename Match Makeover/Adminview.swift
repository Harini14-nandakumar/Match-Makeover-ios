//
//  Adminview.swift
//  Match Makeover
//
//  Created by SAIL on 05/06/25.
//

import SwiftUI
struct Adminview: View {
    var body: some View {
      
            ZStack {
                @Environment(\.dismiss) var dismiss //  For navigation back
 
                Image("bg")
                    .resizable()
              
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    CustomImage(name: "icon")
                    
                    CustomText(
                        text: "Admin",
                        font: .title,
                        weight: .bold,
                        backgroundColor: .clear
                    )
                    
                  
                    
                    NavigationLink(destination: categories()) {
                        Text("Categories")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 50)
                    }
                    
                    NavigationLink(destination: Occasions()) {
                        Text("Occasions")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 50)
                    }
                    
                    NavigationLink(destination: Colours()) {
                        Text("Colours")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 50)
                    }
                    
                    Spacer()
                }
                .padding(.top, 120)
            }
        }
    }



#Preview {
    Adminview()
}
