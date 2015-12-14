//
//  Thumbnail.swift
//  wiki
//
//  Created by dm on 13/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import EasyMapping

class Thumbnail: EKObjectModel {
    var urlString: String!
    var width: NSNumber!
    var height: NSNumber!
}

extension Thumbnail {
    override class func objectMapping() -> EKObjectMapping {
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromDictionary(["source": "urlString", "width": "width", "height": "height"])
        return mapping
    }
}