//
//  colourgrid.swift
//  Match Makeover
//
//  Created by SAIL on 12/06/25.
//
import SwiftUI
struct ColorGridPickerView: View {
    let selectedGender: String

    @State private var colours: [coloursModel] = []
    @State private var selectedColorName: String = ""
    @State private var navigateToUserView4 = false
    @State private var showAlert = false
    @State private var errorMessage = ""

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Choose a Color")
                    .font(.title2.bold())
                    .foregroundColor(.black)

                if colours.isEmpty {
                    ProgressView("Loading colours...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(colours) { colour in
                                VStack {
                                    Circle()
                                        .fill(mapColour(name: colour.name))
                                        .frame(width: 50, height: 50)
                                        .shadow(radius: 2)
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    selectedColorName == colour.name ? Color.black : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                        .onTapGesture {
                                            selectedColorName = colour.name
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                navigateToUserView4 = true
                                            }
                                        }

                                    Text(colour.name.capitalized)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding()
                    }
                }

                if !selectedColorName.isEmpty {
                    HStack {
                        Text("Selected Colour:")
                            .foregroundColor(.black)
                        Circle()
                            .fill(mapColour(name: selectedColorName))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle().stroke(Color.black.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .font(.subheadline)
                    .padding(.top, 10)
                }
            }
            .padding()
        }
        //  Now passing color to userview4
        .navigationDestination(isPresented: $navigateToUserView4) {
            userview4(selectedGender: selectedGender, selectedColor: selectedColorName)
        }
        .onAppear {
            fetchColours()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // Fetch Colours from API
    func fetchColours() {
        guard let url = URL(string: "http://localhost/matchmakeover/colours.php") else {
            errorMessage = "Invalid API URL"
            showAlert = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    showAlert = true
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(coloursRes.self, from: data)
                    self.colours = decoded.colours
                } catch {
                    errorMessage = "Failed to decode colours: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }.resume()
    }

    //  Map Colour Name to SwiftUI Color
    func mapColour(name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "brown": return .brown
        case "gray", "grey": return .gray
        case "black": return .black
        case "white": return .white
        case "teal": return .teal
        case "cyan": return .cyan
        case "indigo": return .indigo
        case "mint": return .mint
        case "primary": return .primary
        case "secondary": return .secondary
        default: return Color.gray.opacity(0.3)
        }
    }
}

//  Preview
#Preview {
    ColorGridPickerView(selectedGender: "Female")
}
