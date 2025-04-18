//
//  Photo.swift
//  bendi.film
//
//  Created by rishabh b on 4/18/25.
//

import Foundation

// A Photo on a Roll of film - all data associated with Photos including aperture and shutterSpeed
struct Photo: Identifiable {
    var id = UUID()                     // unique identifier
    var aperture: String                // aperture
    var shutterSpeed: String            // shutter speed
    var createdAt: Date = Date()        // timestamp when the Photo was taken
    var notes: String                   // notes describing the Photo
}
