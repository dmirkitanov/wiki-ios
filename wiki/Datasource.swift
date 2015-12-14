//
//  Datasource.swift
//  wiki
//
//  Created by dm on 15/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit

protocol DatasourceDelegate: class {
    func datasourceDidFinishLoading(datasource: Datasource, error: NSError?)
    func datasourceDidUpdateObject(datasource: Datasource, atIndexPath indexPath: NSIndexPath)
}

class Datasource: NSObject {
    var isLoading = false

    weak var delegate: DatasourceDelegate?

    convenience init(delegate: DatasourceDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func loadData() {
        fatalError("This method must be overridden")
    }
    
    func reloadData() {
        fatalError("This method must be overridden")
    }

    func loadMoreData() {
        fatalError("This method must be overridden")
    }

    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfObjectsInSection(section: Int) -> Int {
        return 0
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return NSNull()
    }

    func indexPathForObject(object: AnyObject) -> NSIndexPath? {
        return nil
    }
}
