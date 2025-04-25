//
//  RollListView.swift
//  bendi.film
//
//  Created by rishabh b on 4/23/25.
//

import SwiftUI

/*
 - Main View
 */
struct RollListView: View {
    @StateObject var rollViewModel = RollViewModel()
    @State private var showingAddRoll = false
    @State private var isDarkMoode = false
    
    var body: some View {
        NavigationStack{
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
                        
                        Button("Add your first Roll") {
                            showingAddRoll = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    } //VSTACK
                    .padding()
                }
                // Show the List of Rolls
                else {
                    List {
                        ForEach(rollViewModel.rolls) { roll in
                            NavigationLink(destination: PhotoListView(viewModel: viewModel, roll)) {
                                
                            }
                            
                        }
                    }
                }
            } //ZSTACK
        } //NAVIGATIONSTACK
    }
}

#Preview {
    RollListView()
}
