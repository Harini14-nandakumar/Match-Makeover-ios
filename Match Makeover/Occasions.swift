//
//  Occasions.swift
//  Match Makeover
//
//  Created by SAIL on 05/06/25.
//

import SwiftUI
struct Occasions: View {
    
    @State private var navigation: Bool = false
    @State private var occasionList: [OccasionModel] = []
    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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

                    Text("Occasions")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    
                    //  Scrollable Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(occasionList) { occasion in
                                VStack(spacing: 10) {
                                    AsyncImage(url: URL(string: "http://localhost/matchmakeover/\(occasion.image)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 100, height: 100)
                                    
                                    Text(occasion.name.capitalized)
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
                    add_occasions()
                        .onDisappear {
                            fetchOccasions() // 🔁 Refresh when returning
                        }
                }
                .commonAlert(isPresented: $alert, title: "Error", message: errorMessage)
            }
        
        .onAppear {
            fetchOccasions()
        }
    }

    func fetchOccasions() {
        APIHandler.shared.getAPIValues(
            type: OccasionRes.self,
            apiUrl: ServiceAPI.occasions,
            method: "GET"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.occasionList = response.occasions
                case .failure:
                    self.errorMessage = "Failed to load occasions"
                    self.alert = true
                }
            }
        }
    }
}

#Preview {
    Occasions()
}
