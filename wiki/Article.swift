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
    var content: String?
    var revisions: NSArray? {
        didSet {
            if let rev = revisions?[0]["*"] as! String? {
                content = rev
            } else {
                content = nil
            }
        }
    }
    var thumbnail: Thumbnail?

    convenience init(pageId: NSNumber, title: String) {
        self.init()
        self.pageId = pageId
        self.title = title
    }
}

extension Article {
    override class func objectMapping() -> EKObjectMapping {
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromDictionary(["pageid": "pageId", "title": "title", "extract": "summary", "revisions": "revisions"])
        mapping.hasOne(Thumbnail.self, forKeyPath: "thumbnail")
        return mapping
    }
}