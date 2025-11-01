//
//  userview3.swift
//  Match Makeover
//
//  Created by SAIL on 12/06/25.
//

import SwiftUI
struct userview3: View {
    @State private var categories: [CategoryModel] = []
    @State private var errorMessage: String = ""
    @State private var alert: Bool = false
    @Environment(\.dismiss) var dismiss

    let selectedGender = "Kids"

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
     
            ZStack {
                Image("bg")
                    .resizable()
                  
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        Text("Select Categories")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(categories) { category in
                                categoryTile(category)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                fetchKidsCategories()
            }
            .alert("Error", isPresented: $alert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        
    }

    //  Extracted Subview
    @ViewBuilder
    func categoryTile(_ category: CategoryModel) -> some View {
        NavigationLink(destination: ColorGridPickerView(selectedGender: selectedGender)) {
            VStack(spacing: 10) {
                AsyncImage(url: URL(string: "http://localhost/matchmakeover/\(category.image)")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
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

    //  API
    private func fetchKidsCategories() {
        APIHandler.shared.getAPIValues(
            type: CategoriesRes.self,
            apiUrl: ServiceAPI.categories,
            method: "GET"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.categories = response.categories.filter { $0.gender.lowercased() == selectedGender.lowercased() }
                case .failure:
                    self.errorMessage = "Failed to load categories"
                    self.alert = true
                }
            }
        }
    }
}

#Preview {
    userview3()
}
