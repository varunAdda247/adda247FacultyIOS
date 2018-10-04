//
//  ADUtility.swift
//  Adda247
//
//  Created by Varun Tomar on 09/05/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ADUtility: NSObject {
    
    static let pinLength = 6
    
    class func updateFacultyName(name:String) {
        UserDefaults.standard.set(name, forKey: UserKeyConstants.facultyName)
        UserDefaults.standard.synchronize()
    }
    
    class func updateFacultyId(id:String) {
        UserDefaults.standard.set(id, forKey: UserKeyConstants.facultyId)
        UserDefaults.standard.synchronize()
    }
    
    class func updateToken(token:String) {
        UserDefaults.standard.set(token, forKey: UserKeyConstants.token)
        UserDefaults.standard.synchronize()
    }
    
    class func getToken()-> String? {
        return UserDefaults.standard.value(forKey: UserKeyConstants.token) as? String
    }

    class func getFacultyName()-> String? {
        return UserDefaults.standard.value(forKey: UserKeyConstants.facultyName) as? String
    }
    
    class func getFacultyId()-> String? {
        return UserDefaults.standard.value(forKey: UserKeyConstants.facultyId) as? String
    }
    
    class func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()){
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    //Date and Timestamp
    class func timeStampFor(date: Date) -> Double{
        //Return in milisecond
        return date.timeIntervalSince1970*1000
    }
    
    class func timeStampForTodayStartAndEndDate() -> (start:Double,end:Double){
        
        //For start day
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let startDate = calendar.startOfDay(for: Date())
        let startDateTimestamp = self.timeStampFor(date: startDate)
        
        //For End Date
        var components = DateComponents()
        components.day = 10
        components.second = -1
        let endDate = calendar.date(byAdding: components, to: startDate)
        let endDateTimestamp = self.timeStampFor(date: endDate!)

        return (startDateTimestamp,endDateTimestamp)
    }
    
    class func timeFromTimeStamp(timeStamp:Double) -> String{
        //As we get time stamp from server in miliseconds, so divided by 1000
        let unixtimeInterval = timeStamp/1000 //(in seconds)
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h:mm a"
        let strDate = dateFormatter.string(from: date)

        return strDate
    }
    
    class func getObjectAsParameterForClassStartAndEndCall(classes:[TeacherClass],startLocation:String?)-> NSMutableDictionary{
        
        let tempPara:NSMutableDictionary = NSMutableDictionary()
        
        var classListArray:[NSMutableDictionary] = []
        for teacherClass in classes{
            let paramsClass:NSMutableDictionary = NSMutableDictionary()
            paramsClass.setObject(teacherClass.actualStartTs, forKey: "actualStartTs" as NSCopying)
            paramsClass.setObject(teacherClass.actualEndTs, forKey: "actualEndTs" as NSCopying)

            paramsClass.setObject((teacherClass.centerName)!, forKey: "centerName" as NSCopying)
            paramsClass.setObject((teacherClass.classId)!, forKey: "classId" as NSCopying)
            paramsClass.setObject((teacherClass.classNam)!, forKey: "className" as NSCopying)
            paramsClass.setObject((teacherClass.classStatus), forKey: "classStatus" as NSCopying)
            paramsClass.setObject(ADUtility.getFacultyName()!, forKey: "facultyName" as NSCopying)
            paramsClass.setObject(startLocation ?? "", forKey: "startLocation" as NSCopying)
            paramsClass.setObject((teacherClass.startTime), forKey: "startTime" as NSCopying)
            
            classListArray.append(paramsClass)
            
        }
       
        tempPara.setObject(classListArray, forKey: "classDetailsList" as NSCopying)
        
        let (startTimeStamp,endTimeStamp) = ADUtility.timeStampForTodayStartAndEndDate()
        let timeInterval:NSMutableDictionary = NSMutableDictionary()
        timeInterval.setObject(startTimeStamp, forKey: "startTime" as NSCopying)
        timeInterval.setObject(endTimeStamp, forKey: "endTime" as NSCopying)
        tempPara.setObject(timeInterval, forKey: "timeInterval" as NSCopying)
        tempPara.setObject(false, forKey: "isTopicsRequired" as NSCopying)
        
        let facultyId = ADUtility.getFacultyId()!.int16Value
        tempPara.setObject(facultyId, forKey: "facultyId" as NSCopying)
        
        return tempPara
    }
    
}
