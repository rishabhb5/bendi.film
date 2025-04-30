//
//  AddNewRoll.swift
//  bendi.film
//
//  Created by rishabh b on 4/28/25.
//

import SwiftUI

struct AddNewRollView: View {
    
    // Input sent from RollListView
    @ObservedObject var rollViewModel: RollViewModel
   
    @Environment(\.dismiss) private var dismiss
    @State private var inputMemoryName: String = ""
    @State private var inputRollNameIso: String = ""
    
    // Body
    var body: some View {
        
        NavigationStack {
            Form {
                Section(header: Text("Roll Details")) {
                    TextField("Memory Name", text: $inputMemoryName)
                    TextField("Roll Name / Iso", text: $inputRollNameIso)
                }
            }
            .navigationTitle("New Roll")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Save Button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !inputMemoryName.isEmpty && !inputRollNameIso.isEmpty {
                            rollViewModel.addNewRoll(inputMemoryName: inputMemoryName, inputRollNameIso: inputRollNameIso)
                            dismiss()
                        }
                    }
                    // Save button disabled if no input
                    .disabled(inputMemoryName.isEmpty &&
                    inputMemoryName.isEmpty)
                }
            }
        }   //NAVIGATIONSTACK
    }   //VIEW
}

#Preview {
    AddNewRollView(rollViewModel: RollViewModel())
}
