//
//  SectionedDatasource.swift
//  wiki
//
//  Created by dm on 15/12/15.
//  Copyright © 2015 Dmitry Mirkitanov. All rights reserved.
//

import UIKit

protocol SectionedDatasourceDelegate: class {
    func datasourceDidFinishLoading(datasource: SectionedDatasource, error: NSError?)
    func datasourceDidUpdateObject(datasource: SectionedDatasource, atIndexPath indexPath: NSIndexPath)
}

class SectionedDatasource: NSObject {
    var isLoading = false

    weak var delegate: SectionedDatasourceDelegate?

    convenience init(delegate: SectionedDatasourceDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func loadData() {
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
