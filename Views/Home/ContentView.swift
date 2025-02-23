//
//  File.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//


import SwiftUI
import _SwiftData_SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    @Query(sort: \ProductList.name, order: .forward) var productLists: [ProductList]
    @Query(sort: \Products.purchaseDate, order: .reverse) var productsWarranty: [Products]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var isShowingAddListSheet = false
    @State private var isShowingAddItemSheet = false
    @State private var isSelectingToDelete = false
    @State private var activeNotification: ExpiringProductNotification?
    @State private var selectedList: ProductList?
    
    var expiringProducts: [Products] {
        productsWarranty.filter {
            daysRemaining(until: $0.expiryDate) < 15
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
             
                
                if let notification = activeNotification {
                    Notification(notification: notification, onDismiss: {
                        activeNotification = nil
                    })
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: ProductsListView()) {
                    CardView(
                        title: "Individual Items",
                        subtitle: "View all Product Warranties.",
                        icon: "doc.text.image"
                    )
                    .frame(maxWidth: .infinity, alignment: .leading) 
                    .padding(.horizontal)  
                }


                
                if !productLists.isEmpty {
                    HStack {
                        Text("Lists")
                            .font(.headline)
                            .padding(.top)
                        Spacer()
                        Button(action: {
                            isSelectingToDelete.toggle()
                        }) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    
                    ForEach(productLists) { list in
                        HStack {
                            if isSelectingToDelete {
                                Button(action: {
                                    deleteList(list)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            Button(action: {
                                selectedList = list
                            }) {
                                HStack {
                                    Circle()
                                        .fill(colorFromName(list.colorName))
                                        .frame(width: 30, height: 30)
                                    VStack(alignment: .leading) {
                                        Text(list.name)
                                            .font(.headline)
                                        Text("Tap to view list items")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.systemBackground))
                                        .shadow(radius: 3)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No Lists Found")
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                HStack {
                    Button(action: {
                        isShowingAddItemSheet = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: {
                        isShowingAddListSheet = true
                    }) {
                        Label("Add List", systemImage: "folder.badge.plus")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .background(Color(.secondarySystemBackground))
            }
            .navigationTitle("Summary")
            .padding(10)
            .background(Color(uiColor: .secondarySystemBackground))
            .sheet(isPresented: $isShowingAddListSheet) {
                AddListView()
            }
            .sheet(isPresented: $isShowingAddItemSheet) {
                AddProductView(list: nil)
            }
            .navigationDestination(item: $selectedList) { list in
                ProductListView(list: list)
            }
            .onAppear {
                checkForExpiringWarranties()
            }
        }
    }
    
    private func deleteList(_ list: ProductList) {
        modelContext.delete(list)
        do {
            try modelContext.save()
            print("Deleted list: \(list.name)")
        } catch {
            print("Error deleting list: \(error)")
        }
    }
    
    private func daysRemaining(until date: Date) -> Int {
        let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        return remainingDays
    }
    
    private func checkForExpiringWarranties() {
        if let soonExpiringItem = expiringProducts.first {
            activeNotification = ExpiringProductNotification(
                title: "Warranty Expiring Soon!",
                message: "\(soonExpiringItem.name)'s warranty expires in \(daysRemaining(until: soonExpiringItem.expiryDate)) days.",
                products: soonExpiringItem
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                activeNotification = nil
            }
        }
    }
    
    private func colorFromName(_ name: String) -> Color {
        switch name {
        case "red": return .red
        case "yellow": return .yellow
        case "green": return .green
        default: return .gray
        }
    }
}

