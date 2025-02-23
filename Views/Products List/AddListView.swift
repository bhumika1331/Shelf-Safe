//
//  SwiftUIView.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct AddListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var listName = ""
    @State private var selectedColor: String = "red"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("List Name", text: $listName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 2)

                VStack(spacing: 8) {
                    Text("Select Importance Color")
                        .font(.subheadline)
                    
                    HStack(spacing: 15) {
                        ForEach(["red", "yellow", "green"], id: \ .self) { color in
                            Circle()
                                .fill(colorFromName(color))
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
                .padding(.top, 8)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .background(Color(uiColor: .secondarySystemBackground))
            .navigationTitle("Add New List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        addList()
                    }
                    .bold()
                }
            }
        }
        .presentationDetents([.fraction(0.35)])
    }
    
    private func addList() {
        guard !listName.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("List name is empty! Not saving.")
            return
        }

        let newList = ProductList(name: listName, colorName: selectedColor)
        modelContext.insert(newList)

        do {
            try modelContext.save()
            print("New List Saved: \(newList.name) - \(newList.colorName)")
        } catch {
            print("Error saving new list: \(error)")
        }

        dismiss()
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
