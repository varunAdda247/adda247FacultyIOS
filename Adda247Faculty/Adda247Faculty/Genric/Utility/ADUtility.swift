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

//        let temp1:Double = 1506319541000
//        let temp2:Double = 1569391541000
        //return (temp1,temp2)
        return (startDateTimestamp,endDateTimestamp)
    }
}
