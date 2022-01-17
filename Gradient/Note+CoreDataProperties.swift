//
//  Note+CoreDataProperties.swift
//  Gradient
//
//  Created by Brent Meyer on 1/17/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var entry: Entry?

    public var wrappedContent: String {
        content ?? ""
    }

    public var wrappedCreatedAt: Date {
        createdAt ?? Date.now
    }

    public var wrappedId: UUID {
        id ?? UUID()
    }

    public var wrappedUpdatedAt: Date {
        updatedAt ?? Date.now
    }
}

extension Note : Identifiable {

}
