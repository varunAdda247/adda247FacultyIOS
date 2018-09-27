//
//  ADManagedObjectContext.swift
//  Adda247
//
//  Created by Varun Tomar on 24/07/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
        func saveContext() {
            self.performAndWait {
                if self.hasChanges {
                    do {
                        try self.save()
                        if((self.parent) != nil){
                            self.parent?.saveContext()
                        }
                    }
                    catch
                    {
                        print("Problem in DB saving")
                    }
                }
            }
        }
}
