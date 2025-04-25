//
//  Roll.swift
//  bendi.film
//
//  Created by rishabh b on 4/18/25.
//

import Foundation

/*
 - Roll Object
 - A Roll of film - all data associated with a Roll including Photos inside
 - Roll needs to subscribe to Identifiable to use unique identifier: UUID
 */
struct Roll: Identifiable {
    var id = UUID()                 // unique identifier
    var memoryName: String          // name of the memory
    var rollNameIso: String         // ex: Portra 400
    var createdAt: Date = Date()    // timestamp when new Roll created
    var photos: [Photo] = []        // a Roll has an array of Photos
}
