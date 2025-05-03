//
//  RollViewModel.swift
//  bendi.film
//
//  Created by rishabh b on 4/18/25.
//

import Foundation
import SwiftUI


/*
 - Class needs to subscribe to ObservableObject so I can use @Published variables that can be modified.
 - In this class, variable: @Published rolls is the array that can be modified by adding, removing Rolls
 - Only using 1 ViewModel because Rolls and photos have a parent-child relationship - views are tightly coupled
 */
class RollViewModel: ObservableObject {
    
    @Published var rolls: [Roll] = []
    
    // this function adds a new Roll to rolls[]
    func addNewRoll(inputMemoryName: String, inputRollNameIso: String) {
        let newRoll = Roll(memoryName: inputMemoryName, rollNameIso: inputRollNameIso)
        rolls.append(newRoll)
    }
    
    func deleteRoll(at index: IndexSet) {
        rolls.remove(atOffsets: index)
    }
    
    
    // func addPhoto
    
    // func deletePhoto
    
    
    
}
