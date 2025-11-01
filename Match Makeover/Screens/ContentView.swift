//
//  ContentView.swift
//  MatchMakeover
//
//  Created by SAIL01 on 04/06/25.
//

import SwiftUI
struct ContentView: View {
    @State private var navigateToLogin = false
    @State private var animateLogo = false
    @State private var logoScale: CGFloat = 1.0
    @State private var animateText = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .scaleEffect(logoScale)
                        .opacity(animateLogo ? 1 : 0)
                        .onAppear {
                            
                            withAnimation(.easeOut(duration: 0.6)) {
                                logoScale = 1.2
                                animateLogo = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                withAnimation(.interpolatingSpring(stiffness: 100, damping: 8)) {
                                    logoScale = 1.0
                                }
                            }
                        }

                    Text("Match Makeover")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 30)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.2).delay(0.4)) {
                                animateText = true
                            }
                        }
                }
            }
            .onAppear {
                // Navigate to LoginView after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        navigateToLogin = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
