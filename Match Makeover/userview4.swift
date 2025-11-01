//
//  userview4.swift
//  Match Makeover
//
//  Created by SAIL on 12/06/25.
//
import SwiftUI

struct userview4: View {
    let selectedGender: String       // passed from userview1
    let selectedColor: String        // passed from ColorGridPickerView

    @State private var occasions: [OccasionModel] = []
    @State private var isLoading = true
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedOccasion: OccasionModel? = nil

    var body: some View {
 
            ZStack {
                Image("bg")
                    .resizable()
                
                    .ignoresSafeArea()

                VStack {
                    Text("Choose Your Occasion")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .padding(.top)

                    if isLoading {
                        ProgressView("Loading occasions...")
                            .padding()
                    } else if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if filteredOccasions().isEmpty {
                        Text("No occasions found for this color.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(filteredOccasions()) { occasion in
                                    VStack {
                                        AsyncImage(url: URL(string: "http://localhost/matchmakeover/\(occasion.image)")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 150)
                                        } placeholder: {
                                            ProgressView()
                                        }

                                        Text(occasion.name.capitalized)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .onTapGesture {
                                        selectedOccasion = occasion
                                    }
                                }
                            }
                            .padding()
                        }
                    }

                    // ✅ FIX: use Group for conditional destination
                    NavigationLink(
                        destination: Group {
                            if let selected = selectedOccasion {
                                userview5(selectedOccasion: selected, selectedColor: selectedColor)
                            }
                        },
                        isActive: Binding(
                            get: { selectedOccasion != nil },
                            set: { if !$0 { selectedOccasion = nil } }
                        )
                    ) {
                        EmptyView()
                    }
                }
                .onAppear(perform: fetchOccasions)
            }
        
    }

    //Filter Occasions
    func filteredOccasions() -> [OccasionModel] {
        return occasions.filter {
            $0.gender.lowercased() == selectedGender.lowercased() &&
            $0.color.lowercased() == selectedColor.lowercased()
        }
    }

    // Fetch Occasions API
    func fetchOccasions() {
        guard let url = URL(string: "http://localhost/matchmakeover/occasions.php") else {
            self.showError = true
            self.errorMessage = "Invalid API URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }

                guard let data = data else {
                    self.showError = true
                    self.errorMessage = "No data received"
                    self.isLoading = false
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(OccasionRes.self, from: data)
                    if decoded.status == "success" {
                        self.occasions = decoded.occasions
                    } else {
                        self.showError = true
                        self.errorMessage = decoded.message
                    }
                } catch {
                    self.showError = true
                    self.errorMessage = "Decoding failed: \(error.localizedDescription)"
                }

                self.isLoading = false
            }
        }.resume()
    }
}

#Preview {
    userview4(selectedGender: "Female", selectedColor: "Red")
}
