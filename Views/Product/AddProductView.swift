//
//  SwiftUIView.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import SwiftUI
import SwiftData
import PhotosUI

@available(iOS 17.0, *)
struct AddProductView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var list : ProductList?
    
    @State private var productName : String = ""
    @State private var category : String = ""
    @State private var purchaseDate : Date = Date()
    @State private var expiryDate : Date = Date()
    @State private var details = ""
    @State private var selectedType = "Warranty"
    let types = ["Warranty", "Guaranty", "Both"]
    
    @State private var receiptImage: UIImage?
    @State private var cardImage: UIImage?
    @State private var productImage: UIImage?
    
    @State private var isShowingImagePicker = false
    @State private var isShowingActionSheet = false
    @State private var isShowingPhotosPicker = false
    @State private var selectedPhotoPickerItem: PhotosPickerItem?
    
    @State private var selectedImageType: ImageType?
    
    enum ImageType {
        case receipt, warrantyCard, product
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $productName)
                    TextField("Category", text: $category)
                    TextField("Details", text: $details)
                }
                Section(header: Text("Dates")) {
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                }
                Section(header: Text("Coverage Type")) {
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Upload Images")) {
                    imageUploadCell(label: "Bill/Receipt Image", image: receiptImage) {
                        selectedImageType = .receipt
                        isShowingActionSheet = true
                    }
                    imageUploadCell(label: "Warranty/Guaranty Card", image: cardImage) {
                        selectedImageType = .warrantyCard
                        isShowingActionSheet = true
                    }
                    imageUploadCell(label: "Product Image", image: productImage) {
                        selectedImageType = .product
                        isShowingActionSheet = true
                    }
                }
            }
            .navigationTitle(list != nil ? "\(list!.name)" : "Add New Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        addItem()
                    }
                    .bold()
                }
            }
            .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(
                    title: Text("Upload Image"), message: nil, buttons: [
                        .default(Text("Take a Picture")) {
                            isShowingImagePicker = true
                        },
                        .default(Text("Choose from Photos")) {
                            isShowingPhotosPicker = true
                        },
                        .cancel()
                    ]
                )
            }
                .sheet(isPresented: $isShowingImagePicker) {
                     ImagePicker(selectedImage: bindingForSelectedImageType())
                 }
                 .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedPhotoPickerItem, matching: .images)
                 .onChange(of: selectedPhotoPickerItem) { newItem in
                     Task {
                         if let data = try? await newItem?.loadTransferable(type: Data.self),
                            let selectedUIImage = UIImage(data: data) {
                             updateImage(selectedUIImage)
                         }
                     }
                 }
             }
         }
         
                         // helper function
                         private func addItem() {
                             guard !productName.trimmingCharacters(in: .whitespaces).isEmpty else {
                                 print("⚠️ Item name is empty! Not saving.")
                                 return
                             }

                             let newItem = Products(
                                 name: productName,
                                 category: category,
                                 purchaseDate: purchaseDate,
                                 expiryDate: expiryDate,
                                 type: selectedType,
                                 details: details,
                                 receiptImage: receiptImage?.jpegData(compressionQuality: 0.8),
                                 cardImage: cardImage?.jpegData(compressionQuality: 0.8),
                                 productImage: productImage?.jpegData(compressionQuality: 0.8)
                             )

                             if let list = list {
                                 list.products.append(newItem)
                             } else {
                                 modelContext.insert(newItem)
                             }

                             do {
                                 try modelContext.save()
                                 print("New Item Saved: \(newItem.name)")
                             } catch {
                                 print("Error saving new item: \(error)")
                             }

                             dismiss()
                         }
                         
                         // MARK: - Image Handling
                         
                         private func bindingForSelectedImageType() -> Binding<UIImage?> {
                             switch selectedImageType {
                             case .receipt:
                                 return $receiptImage
                             case .warrantyCard:
                                 return $cardImage
                             case .product:
                                 return $productImage
                             case .none:
                                 return .constant(nil)
                             }
                         }
                         
                         private func updateImage(_ image: UIImage) {
                             switch selectedImageType {
                             case .receipt:
                                 receiptImage = image
                             case .warrantyCard:
                                 cardImage = image
                             case .product:
                                 productImage = image
                             case .none:
                                 break
                             }
                         }

                         private func imageUploadCell(label: String, image: UIImage?, action: @escaping () -> Void) -> some View {
                             HStack {
                                 VStack(alignment: .leading) {
                                     Text(label)
                                         .font(.headline)
                                     if let image = image {
                                         Image(uiImage: image)
                                             .resizable()
                                             .scaledToFit()
                                             .frame(height: 100)
                                             .clipShape(RoundedRectangle(cornerRadius: 8))
                                     } else {
                                         Text("Tap to select an image")
                                             .foregroundColor(.gray)
                                             .font(.subheadline)
                                     }
                                 }
                                 Spacer()
                                 Button(action: action) {
                                     Image(systemName: "doc.viewfinder")
                                         .font(.title)
                                         .foregroundColor(.green)
                                 }
                             }
                             .contentShape(Rectangle())
                             .onTapGesture { action() }
                         }
                     }
