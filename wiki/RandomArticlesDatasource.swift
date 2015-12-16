//
//  RandomArticlesDatasource.swift
//  wiki
//
//  Created by dm on 10/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit


class RandomArticlesDatasource: ArticlesDatasource {
    var continueMarker: String?
    
    override func loadData() {
        if isLoading {
            return
        }

        self.isLoading = true

        APIManager.sharedInstance.getRandomArticles(continueMarker: nil, success: { (articles, continueMarker) -> Void in
            self.articles = articles
            self.continueMarker = continueMarker
            self.isLoading = false
            
            self.updateArticlesSummary(articles)
            
            self.delegate?.datasourceDidFinishLoading(self, error: nil)
            }, failure: { (error) -> Void in
                self.isLoading = false
                
                self.delegate?.datasourceDidFinishLoading(self, error: error)
        })
    }
    
    override func loadMoreData() {
        if isLoading {
            return
        }
        
        self.isLoading = true
        
        APIManager.sharedInstance.getRandomArticles(continueMarker: continueMarker, success: { (articles, continueMarker) -> Void in
            self.articles.appendContentsOf(articles)
            self.continueMarker = continueMarker
            self.isLoading = false

            self.updateArticlesSummary(articles)

            self.delegate?.datasourceDidFinishLoading(self, error: nil)
            }, failure: { (error) -> Void in
                self.isLoading = false
                
                self.delegate?.datasourceDidFinishLoading(self, error: error)
        })
    }
}
