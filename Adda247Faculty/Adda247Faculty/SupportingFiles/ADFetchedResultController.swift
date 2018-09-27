//
//  ADFetchedResultController.swift
//  Adda247
//
//  Created by Moazzam Ali Khan on 05/07/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import CoreData


extension NSFetchedResultsController {
     @objc func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.sections,
            indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
}

