//
//  HistoryItem+CoreDataProperties.swift
//  wiki
//
//  Created by dm on 15/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HistoryItem {

    @NSManaged var itemType: NSNumber?
    @NSManaged var title: String?

}
