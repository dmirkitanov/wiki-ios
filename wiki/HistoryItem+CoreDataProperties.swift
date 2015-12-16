//
//  HistoryItem+CoreDataProperties.swift
//  
//
//  Created by dm on 16/12/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HistoryItem {

    @NSManaged var title: String!
    @NSManaged var articlePageId: NSNumber!

}
