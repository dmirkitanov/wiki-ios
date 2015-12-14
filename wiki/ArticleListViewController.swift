//
//  ArticleListViewController.swift
//  wiki
//
//  Created by dm on 09/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleListViewController: UITableViewController, DatasourceDelegate {
    
    var datasource: Datasource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datasource = RandomArticlesDatasource(delegate: self)
        datasource!.loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        self.navigationController!.pushViewController(articleViewController, animated: true)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == tableView.numberOfSections - 1) && (indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1) {
            datasource?.loadMoreData()
        }
    }
    
    func datasourceDidFinishLoading(datasource: Datasource, error: NSError?) {
        if datasource != self.datasource {      // TODO: ?????
            return
        }
        
        tableView.reloadData()
    }
    
    func datasourceDidUpdateObject(datasource: Datasource, atIndexPath indexPath: NSIndexPath) {
        if let visibleRows = tableView.indexPathsForVisibleRows {
            if visibleRows.contains(indexPath) {
                tableView.beginUpdates()
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
            }
        }
    }
    
    @IBAction func refresh() {
        tableView.reloadData()
    }
}
