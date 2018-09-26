//
//  ADCoreDataHandler.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 25/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import UIKit
import CoreData

class ADCoreDataHandler: NSObject {
    
    static let sharedInstance = ADCoreDataHandler()
    
    private override init() {
        
        super.init()
    }
    
    //MARK: - Application's Documents directory path
    lazy private var applicationDocumentsDirectory: URL = {
        
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }()
    
    // MARK: - Managed Object Model
    lazy private var managedObjectModel: NSManagedObjectModel = {
        let objectModelUrl = Bundle.main.url(forResource: "Adda247Faculty", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: objectModelUrl)!
    }()
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
    }
    
    //MARK: - Persistant Store Coordinator
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        var storeUrl = self.applicationDocumentsDirectory.appendingPathComponent("Adda247.sqlite")
        
        do{
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options:  [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
        }
        catch {
            
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        let coordinator = self.persistentStoreCoordinator
        
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    
    //MARK: - Saving main context if it has changes
    func saveContext() {
        self.managedObjectContext.perform {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                }
                catch
                {
                    print("Problem in DB saving")
                }
            }
        }
    }
    
    func saveContextWithWait() {
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                }
                catch
                {
                    print("Problem in DB saving")
                }
            }
        }
    }
}
