//
//  ADHTTPManager.swift
//  Adda247
//
//  Created by Varun Tomar on 30/03/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import Alamofire

class ADHTTPManager{
    
    class func request(_ api:ADServerAPI, completionHandler:@escaping (DataResponse<Any>) -> Void){
        
        Alamofire.request(api).responseJSON(completionHandler: { response in
            
            completionHandler(response)
        })
    }
    
    class func request(baseUrl url:String?, endPoint:String, method:HTTPMethod = .get,parameters:Parameters = [:], encoding:ParameterEncoding = URLEncoding.queryString, completionHandler:@escaping (Any) -> Void){
        
        let headers = ["Platform":"ios","OSVersion":UIDevice.OSVersion,"AppVersionCode":UIApplication.appVersionCode]
        
        var completeUrl = endPoint
        
        if let baseUrl = url {
            completeUrl = "\(baseUrl)/\(endPoint)"
        }
        
        Alamofire.request(completeUrl, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { response in
            
            completionHandler(response)
        })
    }
}
