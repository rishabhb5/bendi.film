//
//  Roll.swift
//  bendi.film
//
//  Created by rishabh b on 4/18/25.
//

import Foundation

struct Roll: Identifiable {
    var id = UUID()                 // unique identifier
    var memoryName: String          // name of the memory
    var rollNameIso: String         // ex: Portra 400
    var createdAt: Date = Date()    // timestamp when picture taken
    var photos: [Photo] = []        // a Roll has an array of Photos
}
