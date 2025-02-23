//
//  SwiftUIView.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct ProductListView: View {
    @Bindable var list: ProductList
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingProduct = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all) 
                
                VStack {
                    if list.products.isEmpty {
                        Text("No Products Found")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(list.products) { product in
                                    WarrantyProductCard(products: product)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle(list.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingProduct = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingProduct) {
                AddProductView(list: list)
            }
        }
    }
}
