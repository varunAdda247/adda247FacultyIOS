//
//  TeacherClass+CoreDataClass.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 25/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TeacherClass)
public class TeacherClass: NSManagedObject {

    class func fetchClassData(parameters:Any?,packageId:String, complitionHandler:@escaping ADBooleanResponseBlock){
        
        _ = ADWebClient.sharedClient.POST(appbBaseUrl:APIURL.baseUrl, suffixUrl: APIURLSuffix.getClasses, parameters: parameters, success: { (response) in
            
            NSLog("LOG : Service data done")
            
            if let responseObject = response as? [String: Any] {
                
                if let package = responseObject["data"] as? [String:Any] {
                    TeacherClass.insertClassInfoInDB(responseData: package, complitionCallback: { (isDataSaved, error) in
                        DispatchQueue.main.async(execute: {
                            if(isDataSaved){
                                complitionHandler(true, nil)
                            }
                            else{
                                complitionHandler(false, error)
                            }
                        })
                    })
                }
            }
        })
        { (error) in
            DispatchQueue.main.async(execute: {
                complitionHandler(false, error)
            })
        }
    }
    
    class func insertClassInfoInDB(responseData: Any,complitionCallback:@escaping ADBooleanResponseBlock)
    {
        let jsonResult = responseData as! Dictionary<String, Any>
        let data = jsonResult["data"] as! Dictionary<String, Any>
        let batches = data["batches"] as! Array<Dictionary<String, Any>>
        
        //Parse and fill data here
        let tempContext = ADCoreDataHandler.sharedInstance.managedObjectContext
        
        tempContext.perform {
            
            //Add paid test info objects
            if(batches.count > 0){
                
                for i in 0...(batches.count - 1){
                    let tempObj = batches[i]
                    let object = TeacherClass.teacherClassForId(context: tempContext, classId: tempObj["classId"] as! String)
                    if(object != nil){
                        //Update here
                        object?.actualEndTs = tempObj["actualEndTs"] as! Double
                        object?.actualStartTs = tempObj["actualStartTs"] as! Double
                        object?.centerName = tempObj["centerName"] as? String
                        object?.classId = (tempObj["classId"] as! NSNumber).stringValue
                        object?.classNam = tempObj["className"] as? String
                        object?.classStatus = (tempObj["classStatus"] as! NSNumber).int16Value
                        object?.endLocation = tempObj["endLocation"] as? String
                        object?.startLocation = tempObj["startLocation"] as? String
                        object?.endTime = (tempObj["endTime"] as! NSNumber).doubleValue
                        //Faculty name
                    }
                }
            }
            
            //SAVE CONTEXT
            NSLog("LOG : Entitys parsing save done")
            complitionCallback(true,nil)
        }
    }
    
    
    class func deletePaidTestInfoFromDB(tempContext:NSManagedObjectContext, set:Set<String>,packageInfo:TeacherClass){
        
    }
    
    
    class func teacherClassForId(context: NSManagedObjectContext,classId:String)-> TeacherClass? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TeacherClass")
        let managedContext = ADCoreDataHandler.sharedInstance.managedObjectContext
        
        let predicate  = NSPredicate(format:"classId = %@",classId)
        fetchRequest.predicate = predicate
        
        var teacherClassObj : TeacherClass
        do {
            let teacherClassArray = try managedContext.fetch(fetchRequest)
            if(teacherClassArray.count == 0){
                teacherClassObj = createTeacherClassObjectForId(context: context, id: classId)
            }
            else{
                teacherClassObj = ((teacherClassArray.last) as? TeacherClass)!
            }
            
        } catch let error as NSError {
            print("Error in DB read : %@",error)
            return nil
        }
        
        return teacherClassObj
    }
    
    class func createTeacherClassObjectForId(context: NSManagedObjectContext,id: String)-> TeacherClass{
        
        var teacherClassObj : TeacherClass
        if #available(iOS 10.0, *) {
            teacherClassObj = TeacherClass(context:ADCoreDataHandler.sharedInstance.managedObjectContext) as TeacherClass
        }
        else{
            teacherClassObj = NSEntityDescription.insertNewObject(forEntityName: "TeacherClass", into: ADCoreDataHandler.sharedInstance.managedObjectContext) as! TeacherClass
        }
        return teacherClassObj
    }
}
