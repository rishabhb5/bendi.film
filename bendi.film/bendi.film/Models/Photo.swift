//
//  Photo.swift
//  bendi.film
//
//  Created by rishabh b on 4/18/25.
//

import Foundation

struct Photo: Identifiable {
    var id = UUID()
    var aperture: String
    var shutterSpeed: String
    var createdAt: Date = Date()
    var notes: String
}
