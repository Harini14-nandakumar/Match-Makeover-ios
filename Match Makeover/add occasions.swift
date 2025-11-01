//
//  add occasions.swift
//  Match Makeover
//
//  Created by SAIL on 05/06/25.
//

import SwiftUI
import PhotosUI

struct add_occasions: View {
    @State private var name: String = ""
    @State private var selectedGender: String = "Male"
    @State private var selectedColor: String = ""

    @State private var topImageItem: PhotosPickerItem? = nil
    @State private var bottomImageItem: PhotosPickerItem? = nil
    @State private var topImage: UIImage? = nil
    @State private var bottomImage: UIImage? = nil

    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccessAlert: Bool = false
    @Environment(\.dismiss) var dismiss

    var onOccasionAdded: (() -> Void)? = nil

    let genders = ["Male", "Female"]
    let colourOptions = ["Red", "Blue", "Green", "Yellow", "Purple", "Pink", "Black", "White", "Orange", "Brown"]

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Enter New Occasion")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 50)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        // Occasion Name
                        TextField("Occasion name", text: $name)
                            .padding()
                            .frame(width: 320)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .font(.title3)

                        // Gender Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Gender")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.leading, 2)

                            Picker("Gender", selection: $selectedGender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender).font(.title3)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 320)
                        }

                        // Color Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Color")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.leading, 2)

                            HStack {
                                Picker("Color", selection: $selectedColor) {
                                    ForEach(colourOptions, id: \.self) { color in
                                        Text(color).font(.title3)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(width: 220)

                                if !selectedColor.isEmpty {
                                    Circle()
                                        .fill(mapColor(name: selectedColor))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle().stroke(Color.black.opacity(0.5), lineWidth: 1)
                                        )
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(10)
                        }

                        // Top Image Picker
                        imagePickerView(
                            title: "Top Image",
                            selectedItem: $topImageItem,
                            image: $topImage
                        )

                        // Bottom Image Picker
                        imagePickerView(
                            title: "Bottom Image",
                            selectedItem: $bottomImageItem,
                            image: $bottomImage
                        )

                        // Upload Button
                        Button("Upload Occasion") {
                            uploadOccasion()
                        }
                        .font(.title3)
                        .foregroundColor(.black)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.bottom, 40)
                        .disabled(name.isEmpty || selectedColor.isEmpty || topImage == nil || bottomImage == nil)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .alert(errorMessage, isPresented: $alert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Occasion Added Successfully!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    onOccasionAdded?()
                    dismiss()
                }
            }
        }
    }

    // MARK: Upload Logic
    private func uploadOccasion() {
        guard let top = topImage, let bottom = bottomImage else {
            errorMessage = "Please select both images."
            alert = true
            return
        }

        guard !name.isEmpty, !selectedColor.isEmpty else {
            errorMessage = "Please fill all fields."
            alert = true
            return
        }

        let formData: [String: Any] = [
            "occasion_name": name,
            "gender": selectedGender.lowercased(),
            "color": selectedColor.lowercased(),
            "image": top,
            "image2": bottom
        ]

        APIHandler.shared.PostUIImageToAPI(
            apiUrl: URL(string: ServiceAPI.addoccasions)!,
            id: UUID().uuidString,
            requestBody: formData
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    if let dict = json as? [String: Any],
                       let status = dict["status"] as? String,
                       status == "success" {
                        showSuccessAlert = true
                    } else {
                        errorMessage = (json as? [String: Any])?["message"] as? String ?? "Unknown error"
                        alert = true
                    }
                case .failure(let err):
                    errorMessage = "Upload failed: \(err.localizedDescription)"
                    alert = true
                }
            }
        }
    }

    // MARK: Map Color Name to SwiftUI Color
    private func mapColor(name: String) -> Color {
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
        default: return .gray.opacity(0.4)
        }
    }

    // MARK: Image Picker View
    @ViewBuilder
    func imagePickerView(
        title: String,
        selectedItem: Binding<PhotosPickerItem?>,
        image: Binding<UIImage?>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 2)

            PhotosPicker(selection: selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .foregroundColor(.gray)
                        .frame(width: 320, height: 180)
                        .background(Color.white.opacity(0.3))

                    if let img = image.wrappedValue {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320, height: 180)
                            .cornerRadius(12)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                            Text("Tap to select image")
                                .foregroundColor(.gray)
                                .font(.body)
                        }
                    }
                }
            }
            .onChange(of: selectedItem.wrappedValue) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        image.wrappedValue = uiImage
                    }
                }
            }
        }
    }
}

#Preview {
    add_occasions()
}
