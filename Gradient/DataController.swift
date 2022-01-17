//
//  DataController.swift
//  Photodex
//
//  Created by Brent Meyer on 1/4/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
   let container = NSPersistentContainer(name: "Gradient")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data load failed: \(error.localizedDescription)")
            }
        }
    }
}
