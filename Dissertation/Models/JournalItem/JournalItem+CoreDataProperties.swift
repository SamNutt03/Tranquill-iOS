//
//  JournalItem+CoreDataProperties.swift
//  Dissertation
//
//  Created by Sam Nuttall on 06/05/2024.
//
//

import Foundation
import CoreData


extension JournalItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalItem> {
        return NSFetchRequest<JournalItem>(entityName: "JournalItem")
    }

    @NSManaged public var createdDate: String?
    @NSManaged public var entry: String?
    @NSManaged public var image: Data?
    @NSManaged public var mood: String?
    @NSManaged public var name: String?

}

extension JournalItem : Identifiable {

}
