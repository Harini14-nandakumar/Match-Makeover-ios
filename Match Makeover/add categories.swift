//
//  add categories.swift
//  Match Makeover
//
//  Created by SAIL on 05/06/25.
//

import SwiftUI
import PhotosUI
struct add_categories: View {

    @State private var name: String = ""
    @State private var selectedGender: String = "Male"
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var pickedImage: UIImage? = nil

    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccessAlert: Bool = false
    @Environment(\.dismiss) var dismiss

    var onCategoryAdded: (() -> Void)? = nil

    let genders = ["Male", "Female"]

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer(minLength: 50)

                Text("Enter New Category")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)

                // Category Name Input
                TextField("Category name", text: $name)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .frame(width: 350)
                    .foregroundColor(.black)
                    .font(.title3)

                // Gender Selector (Segmented)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Gender")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)

                    Picker("Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                                .font(.title3)
                                .tag(gender)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 300)
                }

                // Image Selector Placeholder Box
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundColor(.gray)
                            .frame(width: 300, height: 200)
                            .background(Color.white.opacity(0.4).blur(radius: 0.5))

                        if let uiImage = pickedImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 200)
                                .cornerRadius(12)
                        } else {
                            VStack(spacing: 10) {
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
                .onChange(of: selectedItem) { oldItem, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            pickedImage = uiImage
                        }
                    }
                }


                // Upload Button
                Button(action: uploadCategory) {
                    Text("Upload Category")
                        .font(.title3)
                        .foregroundColor(.black)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .disabled(name.isEmpty || pickedImage == nil)

                Spacer()
            }
            .padding()
            .alert(errorMessage, isPresented: $alert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Category Added Successfully!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    onCategoryAdded?()
                    dismiss()
                }
            }
        }
    }

    //  Upload Function
    private func uploadCategory() {
        guard let image = pickedImage else {
            errorMessage = "Please select an image."
            alert = true
            return
        }
        
        guard let name = name.isEmpty ? nil : name else{
            errorMessage = " Please Enter Name."
            alert = true
            return
        }

        let formData: [String: Any] = [
            "category_name": name,
            "gender": selectedGender.lowercased(),
            "image": image
        ]

        APIHandler.shared.PostUIImageToAPI(
            apiUrl: URL(string: ServiceAPI.addcategories)!,
            id: UUID().uuidString,
            requestBody: formData
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    if let dict = json as? [String: Any],
                       let status = dict["status"] as? String {
                        if status == "success" {
                            showSuccessAlert = true
                        } else {
                            errorMessage = dict["message"] as? String ?? "Unknown error"
                            alert = true
                        }
                    } else {
                        errorMessage = "Invalid response format"
                        alert = true
                    }

                case .failure(let err):
                    errorMessage = "Upload failed: \(err.localizedDescription)"
                    alert = true
                }
            }
        }
    }
}

#Preview {
    add_categories()
}
