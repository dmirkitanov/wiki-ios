//
//  ArticleListViewController.swift
//  wiki
//
//  Created by dm on 09/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleListViewController: UITableViewController, SectionedDatasourceDelegate {
    
    var datasource: SectionedDatasource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datasource = RandomArticlesDatasource(delegate: self)
        datasource!.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (datasource != nil ? datasource!.numberOfSections() : 0)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (datasource != nil ? datasource!.numberOfObjectsInSection(section) : 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ArticleListTableViewCell

        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }

    func configureCell(cell: ArticleListTableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let article = datasource?.objectAtIndexPath(indexPath) as! Article? {
            cell.titleLabel?.text = article.title
            cell.descriptionTextView?.text = article.summary
            if let thumbnailUrl = article.thumbnail?.urlString {
                cell.thumbnailImageView.sd_setImageWithURL(NSURL(string: thumbnailUrl))
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let articleViewController = ArticleViewController()
        if let article = datasource?.objectAtIndexPath(indexPath) as! Article? {
            articleViewController.setArticle(article)

            let historyItem = HistoryItem.MR_createEntity()
            historyItem.articlePageId = article.pageId
            historyItem.title = article.title
            historyItem.managedObjectContext!.MR_saveToPersistentStoreAndWait()

        }
        self.navigationController!.pushViewController(articleViewController, animated: true)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == tableView.numberOfSections - 1) && (indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1) {
            datasource?.loadMoreData()
        }
    }
    
    // MARK: - Datasource delegate

    func datasourceDidFinishLoading(datasource: SectionedDatasource, error: NSError?) {
        // TODO: implement this when search datasource will be available
//        if datasource != self.datasource {
//            return
//        }
        if let refreshControl = self.refreshControl {
            if refreshControl.refreshing {
                refreshControl.endRefreshing()
            }
        }

        tableView.reloadData()
    }
    
    func datasourceDidUpdateObject(datasource: SectionedDatasource, atIndexPath indexPath: NSIndexPath) {
        if let visibleRows = tableView.indexPathsForVisibleRows {
            if visibleRows.contains(indexPath) {
                tableView.beginUpdates()
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
            }
        }
    }

    // MARK: - actions

    @IBAction func refresh() {
        datasource!.loadData()
    }
}
