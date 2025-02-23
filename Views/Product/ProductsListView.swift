//
//  SwiftUIView.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import SwiftUI
import _SwiftData_SwiftUI

@available(iOS 17, *)
struct ProductsListView: View {
    @Query(sort: \Products.purchaseDate, order: .reverse) var productsWarranty: [Products]
    @Environment(\.modelContext) private var modelContext
    
    @State private var isSelectingToDelete = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all) // Ensure full background color
                
                ScrollView {
                    VStack(spacing: 10) {
                        if filteredWarrantyProducts.isEmpty {
                            Text("No Products Found")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            ForEach(filteredWarrantyProducts) { product in
                                HStack {
                                    if isSelectingToDelete {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                            .onTapGesture {
                                                deleteItem(product)
                                            }
                                    }
                                    WarrantyProductCard(products: product)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSelectingToDelete.toggle()
                    }) {
                        Label("Delete", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                print("Total Products Fetched: \(productsWarranty.count)") 
            }
        }
    }
    
    private var filteredWarrantyProducts: [Products] {
        productsWarranty
    }
    
    private func deleteItem(_ product: Products) {
        modelContext.delete(product)
        do {
            try modelContext.save()
            print("Deleted product: \(product.name)")
        } catch {
            print("Error deleting product: \(error)")
        }
    }
}
