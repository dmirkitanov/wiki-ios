//
//  ArticleViewController.swift
//  wiki
//
//  Created by dm on 09/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import SVProgressHUD

class ArticleViewController: UIViewController, ArticleDatasourceDelegate {

    let baseURLString = "https://en.wikipedia.org"
    var datasource = ArticleDatasource()
    
    @IBOutlet weak var webView: UIWebView!

    var bookmarkBarButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookmarkBarButtonItem = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "bookmark")
        navigationItem.rightBarButtonItem = bookmarkBarButtonItem
        
        datasource.delegate = self

        webView.loadHTMLString("Loading...", baseURL: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBookmarkBarButtonItem()
    }
    
    func setArticle(article: Article) {
        datasource.loadArticle(article)
        self.title = article.title
    }
    
    func getBookmark() -> Bookmark? {
        if let article = datasource.article {
            if let bookmark = Bookmark.MR_findFirstWithPredicate(NSPredicate(format: "articlePageId = %@", article.pageId)) {
                return bookmark
            }
        }
        
        return nil
    }
    
    func updateBookmarkBarButtonItem() {
        bookmarkBarButtonItem?.image = UIImage(named: (getBookmark() != nil ? "navbar_icon_star_full" : "navbar_icon_star_empty"))
    }

    func bookmark() {
        if let article = datasource.article {
            if let bookmark = getBookmark() {
                bookmark.MR_deleteEntity()
                bookmark.managedObjectContext!.MR_saveToPersistentStoreAndWait()
                
                SVProgressHUD.showImage(UIImage(named: "hud_star_empty"), status: "Removed from bookmarks")
            } else {
                let bookmark = Bookmark.MR_createEntity()
                bookmark.articlePageId = article.pageId
                bookmark.title = article.title
                bookmark.managedObjectContext!.MR_saveToPersistentStoreAndWait()
                
                SVProgressHUD.showImage(UIImage(named: "hud_star_full"), status: "Added to bookmarks")
            }

            updateBookmarkBarButtonItem()
        }
    }

    // MARK: - Datasource delegate

    func datasourceDidFinishLoading(datasource: ArticleDatasource, error: NSError?) {
        self.title = (datasource.article?.title)!
        webView.loadHTMLString((datasource.article?.content)!, baseURL: NSURL(string: baseURLString))
    }
}
