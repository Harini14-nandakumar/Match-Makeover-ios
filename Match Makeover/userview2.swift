//
//  userview2.swift
//  Match Makeover
//
//  Created by SAIL on 12/06/25.
//

import SwiftUI
struct userview2: View {
    @State private var categoryList: [CategoryModel] = []
    @State private var errorMessage: String = ""
    @State private var alert: Bool = false
    @State private var navigateToColorGrid = false
    @Environment(\.dismiss) var dismiss

    let selectedGender = "Female"  // Hardcoded since this is the female view

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
     
            ZStack {
                Image("bg")
                    .resizable()
                 
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Select Categories")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 20)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(categoryList) { category in
                                Button(action: {
                                    navigateToColorGrid = true
                                }) {
                                    VStack(spacing: 10) {
                                        AsyncImage(url: URL(string: "http://localhost/matchmakeover/\(category.image)")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 120, height: 120)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 3)

                                        Text(category.name.capitalized)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.95))
                                    .cornerRadius(14)
                                    .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .padding()
            }
            .onAppear {
                fetchFemaleCategories()
            }
            .navigationDestination(isPresented: $navigateToColorGrid) {
                ColorGridPickerView(selectedGender: selectedGender)
            }
            .commonAlert(isPresented: $alert, title: "Error", message: errorMessage)
        
    }

    func fetchFemaleCategories() {
        APIHandler.shared.getAPIValues(
            type: CategoriesRes.self,
            apiUrl: ServiceAPI.categories,
            method: "GET"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.categoryList = response.categories.filter { $0.gender.lowercased() == selectedGender.lowercased() }
                case .failure:
                    self.errorMessage = "Failed to load categories"
                    self.alert = true
                }
            }
        }
    }
}

#Preview {
    userview2()
}
