//
//  Category.swift
//  wiki
//
//  Created by dm on 16/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import EasyMapping

class Category: EKObjectModel {
    var title: String! {
        didSet {
            let tag = "Category:"
            if title.hasPrefix(tag) {
                title = title.substringFromIndex(tag.endIndex)
            }
        }
    }
}

extension Category {
    override class func objectMapping() -> EKObjectMapping {
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromDictionary(["title": "title"])
        return mapping
    }
}