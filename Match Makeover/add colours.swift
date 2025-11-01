//
//  add colours.swift
//  MatchMakeover
//
//  Created by SAIL01 on 04/06/25.
//

import SwiftUI
struct add_colours: View {
    @State private var name: String = ""
    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccessAlert: Bool = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer(minLength: 80)

                    Text("Enter New Colour")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    TextField("Colour Name", text: $name)
                        .padding()
                        .frame(height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)

                    Button(action: {
                        if name.trimmingCharacters(in: .whitespaces).isEmpty {
                            errorMessage = "Please enter a colour name"
                            alert = true
                        } else {
                            uploadColour()
                        }
                    }) {
                        Text("Enter")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal, 100)

                    Spacer()
                }
                .padding()
            }
            .alert("Error", isPresented: $alert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .alert("Colour Added Successfully!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    //  Upload Function
    func uploadColour() {
        guard let url = URL(string: "http://localhost/matchmakeover/newcolours.php") else {
            errorMessage = "Invalid API URL"
            alert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["colour_name": name.trimmingCharacters(in: .whitespaces)]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            errorMessage = "Failed to encode request"
            alert = true
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    alert = true
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    alert = true
                    return
                }

                do {
                    if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = result["status"] as? String,
                       let message = result["message"] as? String {

                        if status.lowercased() == "success" {
                            showSuccessAlert = true
                        } else {
                            errorMessage = message
                            alert = true
                        }
                    } else {
                        errorMessage = "Invalid response format"
                        alert = true
                    }
                } catch {
                    errorMessage = "Failed to parse server response"
                    alert = true
                }
            }
        }.resume()
    }
}

#Preview {
    add_colours()
}
