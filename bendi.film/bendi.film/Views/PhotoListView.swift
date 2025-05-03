//
//  PhotoListView.swift
//  bendi.film
//
//  Created by rishabh b on 4/25/25.
//

/*
 - 20250426: Understanding concept of manipulating a data structure (in this case the rolls array)
    - displaying the array in a List -> ForEach structure in the Views
 - 20250429: Every View has a body, can take input
 */


import SwiftUI

struct PhotoListView: View {
    
    // Input sent from RollListView
    @ObservedObject var rollViewModel: RollViewModel
    var roll: Roll
    
    @State private var showingAddPhoto = false
    
    // Body
    var body: some View {
        List {
            ForEach(roll.photos) { photo in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        // Add the Index for the photo array
                        // Text
                        
                        Text("Aperture: f/\(photo.aperture)")
                            .font(.headline)
                       
                        Spacer()
                        
                        Text("Shutter: 1/\(photo.shutterSpeed)s")
                            .font(.headline)
                    } /*HSTACK*/
                    
                    if !photo.notes.isEmpty {
                        Text(photo.notes)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                } /*VSTACK*/
            } /*FOREACH*/
        } /*LIST*/
    } /*BODY*/
} /*VIEW*/

//#Preview {
//    PhotoListView(rollViewModel: RollViewModel, roll: Roll)
//}
