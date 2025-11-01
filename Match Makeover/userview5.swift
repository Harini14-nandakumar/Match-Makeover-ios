//
//  userview5.swift
//  Match Makeover
//
//  Created by SAIL on 12/06/25.
//
import SwiftUI

struct userview5: View {
    let selectedOccasion: OccasionModel
    let selectedColor: String  //  Add this to show color
    @Environment(\.dismiss) var dismiss
    @State private var navigateToChat = false

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .ignoresSafeArea()

            VStack {
                // Custom Bold Title
                Text("Selected Occasion")
                    .font(.title.bold())
                    .foregroundColor(.black)
                    .padding(.top, 30)

                ScrollView {
                    VStack(spacing: 25) {
                        // Image Grid
                        HStack(spacing: 20) {
                            occasionImageView(imageURL: selectedOccasion.image)
                            occasionImageView(imageURL: selectedOccasion.image2)
                        }
                        .padding(.top, 10)

                        // Occasion Info Box
                        VStack(spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.purple)
                                Text("Occasion: \(selectedOccasion.name.capitalized)")
                                    .font(.title3.bold())
                                    .foregroundColor(.black)
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "paintpalette.fill")
                                    .foregroundColor(.pink)
                                Text("Color: \(selectedColor.capitalized)") //  Showing color
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.95))
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 30)

                        // Chat Button
                        Button(action: {
                            withAnimation(.spring()) {
                                navigateToChat = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Ask StyleBot")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.horizontal, 30)
                        }

                        NavigationLink(destination: Chatbox(), isActive: $navigateToChat) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarBackButtonHidden(false) // Keep back button
    }

    //  Image View Helper
    func occasionImageView(imageURL: String) -> some View {
        AsyncImage(url: URL(string: "http://localhost/matchmakeover/\(imageURL)")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 160, height: 220)
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        userview5(
            selectedOccasion: OccasionModel(
                id: 1,
                name: "Party Wear",
                image: "top_image.jpg",
                image2: "bottom_image.jpg",
                gender: "female",
                color: "Red"
            ),
            selectedColor: "Red" //  Example color
        )
    }
}

