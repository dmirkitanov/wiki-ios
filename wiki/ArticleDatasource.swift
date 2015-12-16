//
//  ArticleDatasource.swift
//  wiki
//
//  Created by dm on 15/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit

protocol ArticleDatasourceDelegate: class {
    func datasourceDidFinishLoading(datasource: ArticleDatasource, error: NSError?)
}

class ArticleDatasource: NSObject {
    var isLoading = false
    var article: Article?

    weak var delegate: ArticleDatasourceDelegate?
    
    override init() {
        super.init()
    }
    
    convenience init(delegate: ArticleDatasourceDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func loadArticle(article: Article) {
        if isLoading {
            return
        }
        
        self.isLoading = true
        self.article = article
        
        APIManager.sharedInstance.getArticleContent(article.pageId.integerValue, success: { (article) -> Void in
            self.article = article
            self.isLoading = false
            
            self.delegate?.datasourceDidFinishLoading(self, error: nil)
            }, failure: { (error) -> Void in
                self.isLoading = false
                
                self.delegate?.datasourceDidFinishLoading(self, error: error)
        })
    }
}