//
//  Topic+CoreDataProperties.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 25/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var index: Int16
    @NSManaged public var status: Int16
    @NSManaged public var name: String?

}
