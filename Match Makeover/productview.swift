//
//  productview.swift
//  Match Makeover
//
//  Created by SAIL on 23/06/25.
//

import SwiftUI
import PhotosUI

struct ProductView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategory = ""
    @State private var selectedOccasion = ""
    @State private var selectedColour = ""
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []

    @State private var showAlert = false
    @State private var alertMessage = ""

    // Sample static lists (replace with dynamic if needed)
   
    let categories = ["Shirts", "T-Shirts", "Jumpsuits"]
    let occasions = ["Party", "Casual", "Formal"]
    let colours = ["Red", "Blue", "Green"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    Text("Add Product")
                        .font(.largeTitle)
                        .bold()

                  
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                    // Occasion Picker
                    Picker("Occasion", selection: $selectedOccasion) {
                        ForEach(occasions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                    // Colour Picker
                    Picker("Colour", selection: $selectedColour) {
                        ForEach(colours, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                    // Photos Picker
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 5,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Label("Select Images", systemImage: "photo.on.rectangle.angled")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                    }

                    // Image Preview
                    if !images.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(images, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }

                    // Submit Button
                    Button("Submit Product") {
                        alertMessage = "Form filled. Ready to upload when backend is ready."
                        showAlert = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .onChange(of: selectedItems) { newItems in
                Task {
                    images = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                }
            }
            .alert("Info", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    ProductView()
}
