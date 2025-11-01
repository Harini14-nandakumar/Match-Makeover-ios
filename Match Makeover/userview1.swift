//
//  userview1.swift
//  Match Makeover
//
//  Created by SAIL on 05/06/25.
//

import SwiftUI
struct userview1: View {
    @State private var selectedGender: String? = nil
    @State private var navigateToFemaleView = false
    @State private var navigateToKidsView = false
    @State private var navigateToColorGrid = false
    @State private var navigateToOccasionView = false
    @State private var navigateToLogin = false

    @State private var allCategories: [CategoryModel] = []
    @State private var filteredCategories: [CategoryModel] = []
    @State private var Alert: Bool = false
    @State private var errorMessage = ""

    let genders = ["Male", "Female"]
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
      
            ZStack {
                Image("bg")
                    .resizable()
                
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)

                        Text("Welcome to Match Makeover")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text("Pick your style")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 20) // Reduced from 50 to fix spacing

                    //  Gender Picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Gender")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        Menu {
                            ForEach(genders, id: \.self) { gender in
                                Button(action: {
                                    selectedGender = gender
                                    filterCategories(for: gender)
                                    if gender == "Female" {
                                        navigateToFemaleView = true
                                    } else if gender == "Kids" {
                                        navigateToKidsView = true
                                    }
                                }) {
                                    Label(gender, systemImage: genderIcon(gender))
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedGender ?? "Select Gender")
                                    .foregroundColor(selectedGender == nil ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                    //  Categories Header
                    if selectedGender != nil {
                        Text("Select Categories")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 5)
                    }

                    // Categories List
                    ScrollView {
                        if filteredCategories.isEmpty {
                            Text("No categories available.")
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        } else {
                            LazyVGrid(columns: columns, spacing: 24) {
                                ForEach(filteredCategories) { category in
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
                                            .frame(width: 100, height: 100)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 3)

                                            Text(category.name)
                                                .font(.footnote)
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.center)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(14)
                                        .shadow(radius: 3)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }

                        // Quote
                        VStack(spacing: 12) {
                            Image(systemName: "hanger")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.purple.opacity(0.7))
                                .padding(.top, 20)

                            Text("“Style is a way to say who you are without having to speak.”")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top) // Push VStack to top
                .padding(.horizontal)
            }

            //  Toolbar (Logout)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        navigateToLogin = true
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
            }

            // Navigation Destinations
            .navigationDestination(isPresented: $navigateToFemaleView) {
                userview2()
            }
            .navigationDestination(isPresented: $navigateToKidsView) {
                userview3()
            }
            .navigationDestination(isPresented: $navigateToColorGrid) {
                ColorGridPickerView(selectedGender: selectedGender ?? "Male")
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }

            // Alert
            .alert("Error", isPresented: $Alert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }

            .onAppear {
                fetchCategories()
            }
        
    }

    func fetchCategories() {
        APIHandler.shared.getAPIValues(
            type: CategoriesRes.self,
            apiUrl: ServiceAPI.categories,
            method: "GET"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.allCategories = response.categories
                    if let selected = selectedGender {
                        self.filterCategories(for: selected)
                    }
                case .failure:
                    self.errorMessage = "Failed to load categories"
                    self.Alert = true
                }
            }
        }
    }

    func filterCategories(for gender: String) {
        self.filteredCategories = allCategories.filter {
            $0.gender.uppercased() == gender.uppercased()
        }
    }

    func genderIcon(_ gender: String) -> String {
        switch gender.lowercased() {
        case "male": return "person"
        case "female": return "person.fill"
        case "kids": return "face.smiling"
        default: return "questionmark"
        }
    }
}

#Preview {
    userview1()
}
