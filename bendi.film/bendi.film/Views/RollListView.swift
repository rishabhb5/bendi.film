//
//  RollListView.swift
//  bendi.film
//
//  Created by rishabh b on 4/23/25.
//

import SwiftUI

/*
 - Main View: using @StateObject instead of @ObservedObject
 */
struct RollListView: View {
    @StateObject var rollViewModel = RollViewModel()
    @State private var showingAddRoll = false
    
    // Body
    var body: some View {
        NavigationStack {
    
            // Applying all
            ZStack {
                // if there are No Rolls
                if rollViewModel.rolls.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "camera.fill")
                            .font(.system(size:60))
                            .foregroundColor(.secondary)
                        
                        Text("No Rolls")
                            .font(.title2)
                        
                        Text("Tap the + button to add a new Roll")
                            .foregroundColor(.secondary)
                    } //VSTACK
                    .padding()
                }
                // Show the List of Rolls
                else {
                    List {
                        ForEach(rollViewModel.rolls) { roll in
                            //NavigationLink(destination: PhotoListView(rollViewModel: rollViewModel, roll: roll)) {
                            //}
                            
                            HStack {
                                Text(roll.memoryName)
                                Text(roll.rollNameIso)
                            }
                            
                        }
                    }
                }
            } //ZSTACK
            .navigationTitle("Camera Rolls")
            .toolbar {
                Button {
                    // this part is the Button's action closure - when a user taps, then this portion of the code is run which changes the state of showingAddRoll
                    // when showingAddRoll's state changes to true -> SwiftUI automatically triggers the AddNewRoll sheet
                    showingAddRoll = true
                } label: {
                    Label("Add Roll", systemImage: "plus")
                }
                .sheet(isPresented: $showingAddRoll) {
                    AddNewRollView(rollViewModel: rollViewModel)
                }
            }
        } //NAVIGATIONSTACK
    }
}

#Preview {
    RollListView()
}
