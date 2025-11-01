//
//  categories.swift
//  Match Makeover
//
//  Created by SAIL on 05/06/25.
//

import SwiftUI
struct categories: View {

    @State private var navigation: Bool = false
    @State private var categoryList: [CategoryModel] = []
    @State private var errorMessage: String = ""
    @State private var alert: Bool = false
    @Environment(\.dismiss) var dismiss  // For navigation back

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
      
            ZStack {
                Image("bg")
                    .resizable()
                  
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    //  Fixed Header
                    HStack {
                        Spacer()
                        CustomButtonImage(title: "", imageName: "plus") {
                            navigation = true
                        }
                        .frame(width: 85)
                        .padding(.trailing)
                    }

                    Text("Categories")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)

                    //  Scrollable Category Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(categoryList) { category in
                                VStack {
                                    AsyncImage(url: URL(string: "http://localhost/matchmakeover/\(category.image)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 100, height: 100)

                                    Text(category.name.capitalized)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                            }
                        }
                        .padding(.top, 10)
                    }

                    Spacer(minLength: 30)
                }
                .padding()
                .navigationDestination(isPresented: $navigation) {
                    add_categories()
                        .onDisappear {
                            fetchCategories() //  Refresh when returning
                        }
                }
                .commonAlert(isPresented: $alert, title: "Error", message: errorMessage)
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
                    self.categoryList = response.categories
                case .failure:
                    self.errorMessage = "Failed to load categories"
                    self.alert = true
                }
            }
        }
    }
}

#Preview {
    categories()
}
