//
//  ArticlesDatasource.swift
//  wiki
//
//  Created by dm on 15/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit

class ArticlesDatasource: Datasource {
    var articles: [Article] = []
    
    override init() {
        super.init()
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func numberOfObjectsInSection(section: Int) -> Int {
        return articles.count
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return articles[indexPath.row]
    }

    override func indexPathForObject(object: AnyObject) -> NSIndexPath? {
        if let idx = articles.indexOf(object as! Article) {
            return NSIndexPath(forRow: idx, inSection: 0)
        }
        
        return nil
    }
    
    func updateArticlesSummary(articles: [Article]) {
        let queue = NSOperationQueue()
        for articleToUpdate in articles {
            if let indexPath = self.indexPathForObject(articleToUpdate) {
                queue.addOperationWithBlock({ () -> Void in
                    APIManager.sharedInstance.getArticleSummary(articleToUpdate.pageId.integerValue, success: { (article) -> Void in
                        self.articles[indexPath.row] = article
                        self.delegate?.datasourceDidUpdateObject(self, atIndexPath: indexPath)
                        }, failure: nil)
                })
            }
        }
    }
}
