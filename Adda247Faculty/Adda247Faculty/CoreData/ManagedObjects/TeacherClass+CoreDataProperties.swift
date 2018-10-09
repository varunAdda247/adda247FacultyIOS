//
//  TeacherClass+CoreDataProperties.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 09/10/18.
//  Copyright © 2018 Adda247. All rights reserved.
//
//

import Foundation
import CoreData


extension TeacherClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeacherClass> {
        return NSFetchRequest<TeacherClass>(entityName: "TeacherClass")
    }

    @NSManaged public var actualEndTs: Int64
    @NSManaged public var actualStartTs: Int64
    @NSManaged public var centerName: String?
    @NSManaged public var classId: String?
    @NSManaged public var classNam: String?
    @NSManaged public var classStatus: Int16
    @NSManaged public var endLocation: String?
    @NSManaged public var endTime: Int64
    @NSManaged public var facultyName: String?
    @NSManaged public var lastUpdatedTs: Int64
    @NSManaged public var startLocation: String?
    @NSManaged public var startTime: Int64
    @NSManaged public var isUpdatedOnServer: Bool
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
