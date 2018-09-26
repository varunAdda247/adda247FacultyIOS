//
//  ADAPIManager.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 25/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import CoreData

class ADAPIManager : NSObject {
    
    class func fetchClassData(parameters:Any?,packageId:String, complitionHandler:@escaping ADBooleanResponseBlock){

        _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: APIURLSuffix.getClasses, parameters: parameters, success: { (response) in
            if let response = response as? Dictionary<String,Any>{
                if let data = response["data"] as? Dictionary<String,Any>{
                    /*
                     {
                     actualEndTs = 1531809843146;
                     actualStartTs = 1531809833459;
                     centerName = "Agra - Bhagwan Talkies";
                     classId = 104; // PRIMARY KEY
                     className = "ABT087-006-Science";
                     classStatus = 2; //0: Not started(missed, upcoming, going to start), 1: Active, 2: Completed
                     endLocation = "28.4437044:77.055694"; // location
                     endTime = 1531819800000; // Actual time set by server
                     facultyName = "<null>"; //
                     lastUpdatedTs = 1531809843146; // to manage latest data in DB
                     startLocation = "28.4437044:77.055694";// location
                     startTime = 1531816200000;// Actual time set by server
                     topics = "<null>";topicId,status(0:fresh, 1: Started but not finish,2:Finished),topicName
                     },
                     */
                    
                    //Open home view conntroller
                    DispatchQueue.main.async(execute: {
                        
                    })
                }
                
                if let message = response["message"] as? String{
                    print(message)
                }
                DispatchQueue.main.async(execute: {
                    //self.hideActivityIndicatorView()
                })
            }
            
            DispatchQueue.main.async(execute: {
                //self.hideActivityIndicatorView()
            })
            
        }) { (error) in
            DispatchQueue.main.async(execute: {
//                self.hideActivityIndicatorView()
//                self.showAlertMessage("Please check your internet connection", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            })
        }
    }
}
