//
//  Entry+CoreDataProperties.swift
//  Gradient
//
//  Created by Brent Meyer on 4/3/22.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var sentiment: Int64
    @NSManaged public var updatedAt: Date?
    @NSManaged public var note: Note?

    public var wrappedCreatedAt: Date {
        createdAt ?? Date.now
    }

    public var wrappedDate: Date {
        date ?? Date.now
    }

    public var wrappedId: UUID {
        id ?? UUID()
    }

    public var wrappedSentiment: Int {
        Int(sentiment)
    }

    public var wrappedUpdatedAt: Date {
        date ?? Date.now
    }
}

extension Entry : Identifiable {

}
