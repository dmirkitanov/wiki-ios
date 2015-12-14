//
//  Article.swift
//  wiki
//
//  Created by dm on 13/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import EasyMapping

class Article: EKObjectModel  {
    var pageId: NSNumber!
    var title: String!
    var summary: String?
    var thumbnail: Thumbnail?
}

extension Article {
    override class func objectMapping() -> EKObjectMapping {
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromDictionary(["pageid": "pageId", "title": "title", "extract": "summary"])
        mapping.hasOne(Thumbnail.self, forKeyPath: "thumbnail")
        return mapping
    }
}