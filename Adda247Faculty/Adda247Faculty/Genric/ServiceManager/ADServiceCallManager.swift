//
//  ADServiceCallManager.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 09/10/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ADServiceCallManager: NSObject {
    
    class func sendPandingDataToServer(array : [TeacherClass]){
        
        if(Reachability.connectionAvailable()){
            
            let tempPara = ADUtility.getObjectAsParameterForClassStartAndEndCall(classes: array)
            
            _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: APIURLSuffix.getClasses, parameters: tempPara, success: { (response) in
                if let response = response as? Dictionary<String,Any>{
                    if let success = response["success"] as? NSNumber{
                        if(success.boolValue){
                            //Set is updated one on server
                            print("Sending data successfull")
                            for object in array{
                                object.isUpdatedOnServer = true
                            }
                            ADCoreDataHandler.sharedInstance.saveContext()
                        }
                    }
                }
            }, failure: { (error) in
                
            })
        }
    }
    
}
