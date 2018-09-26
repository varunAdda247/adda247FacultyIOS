//
//  TeacherClass+CoreDataProperties.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 25/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//
//

import Foundation
import CoreData


extension TeacherClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeacherClass> {
        return NSFetchRequest<TeacherClass>(entityName: "TeacherClass")
    }

    @NSManaged public var actualEndTs: Double
    @NSManaged public var actualStartTs: Double
    @NSManaged public var centerName: String?
    @NSManaged public var classId: String?
    @NSManaged public var classNam: String?
    @NSManaged public var classStatus: Int16
    @NSManaged public var endLocation: String?
    @NSManaged public var startLocation: String?
    @NSManaged public var lastUpdatedTs: Double
    @NSManaged public var startTime: Double
    @NSManaged public var endTime: Double
    @NSManaged public var topics: NSSet?

}

// MARK: Generated accessors for topics
extension TeacherClass {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: Topic)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: Topic)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}
