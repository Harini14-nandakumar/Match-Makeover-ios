//
//  Colours.swift
//  MatchMakeover
//
//  Created by SAIL01 on 04/06/25.
//

import SwiftUI
struct Colours: View {
    @State private var navigation: Bool = false
    @State private var colourList: [coloursModel] = []
    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
    
            ZStack {
                Image("bg")
                    .resizable()
                
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Fixed Header
                    HStack {
                        Spacer()
                        CustomButtonImage(title: "", imageName: "plus") {
                            navigation = true
                        }
                        .frame(width: 85)
                        .padding(.trailing)
                    }

                    CustomText(
                        text: "Colours",
                        font: .title,
                        weight: .bold,
                        backgroundColor: .clear
                    )

                    // Scrollable Colour List
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(colourList, id: \.id) { colour in
                                Text(colour.name.capitalized)
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .frame(width: 300, height: 50)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                    .padding(.vertical, 5)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .padding(.top)
                    }

                    Spacer(minLength: 20)
                }
                .padding()
                .navigationDestination(isPresented: $navigation) {
                    add_colours()
                        .onDisappear {
                            fetchColours()
                        }
                }
                .commonAlert(isPresented: $alert, title: "Error", message: errorMessage)
            }
        
        .onAppear {
            fetchColours()
        }
    }

    // Fetch colours from backend
    func fetchColours() {
        APIHandler.shared.getAPIValues(
            type: coloursRes.self,
            apiUrl: ServiceAPI.colours,
            method: "GET"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.colourList = response.colours
                case .failure:
                    self.errorMessage = "Failed to load colours"
                    self.alert = true
                }
            }
        }
    }
}

#Preview {
    Colours()
}
