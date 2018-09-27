//
//  ADURLSessionManager.swift
//  Adda247
//
//  Created by Varun Tomar on 05/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

class ADURLSessionManager : NSObject, URLSessionDelegate{
    
    var baseURL:String!
    var session:URLSession!
    var HTTPRequestHeaders:Dictionary<String, Any>!
    var sessionConfiguration:URLSessionConfiguration!
    var contentType:String!
    
    init(withConfiguration configuration:URLSessionConfiguration?) {
        
        super.init()
        
        self.sessionConfiguration = configuration
        
        if configuration == nil {
            self.sessionConfiguration = URLSessionConfiguration.default
        }
        self.session = URLSession.init(configuration: self.sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func dataTaskWithRequest(_ request:URLRequest,completionHandler:@escaping (_ responseData:AnyObject?,_ error:ADError?)->Void)->URLSessionDataTask
    {
        let dataTask = self.session.dataTask(with: request) { (data, response, error) in
            print("Data : \(String(describing: data))")
            print("Response : \(String(describing: response))")
            print("Error : \(String(describing: error))")
            
            let httpResponse = response as? HTTPURLResponse
            print("****Response Status Code**** : \(String(describing: httpResponse?.statusCode))")
            //Ckeck if we have status code 200 as in some case we get data nil from server even in success : For example ForgotPassword
            if let statusCode = httpResponse?.statusCode{
                if(String(describing: statusCode) == "200"  && ((data?.count) == 0)){
                    completionHandler("Success" as AnyObject,nil)
                }
            }
            
            if let networkError = error as? NSError ,
                networkError.code == NSURLErrorCannotFindHost ||
                    networkError.code == NSURLErrorNetworkConnectionLost ||
                    networkError.code == NSURLErrorDNSLookupFailed ||
                    networkError.code == NSURLErrorCannotConnectToHost ||
                    networkError.code == NSURLErrorCannotFindHost ||
                    networkError.code == NSURLErrorNotConnectedToInternet ||
                    networkError.code == NSURLErrorTimedOut
            {
                let message:String = (networkError.code == NSURLErrorTimedOut) ? "request_timeout" : "NoInternet"
                let error = ADError(errorDomain: ADErrorDomain.NetworkErrorDomain.rawValue, errorCode: NSURLErrorNotConnectedToInternet, localizedDescription: message)
                completionHandler(nil,error)
            }
            else if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode >= 400
            {
                let error = ADError(errorDomain: ADErrorDomain.NetworkErrorDomain.rawValue, errorCode: NSURLErrorNotConnectedToInternet, localizedDescription: NSLocalizedString("serivce_not_available", comment:""))
                if data != nil {
                    let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //print(datastring!)
                    let serializeResponse = self.serializeResponseData(response, data: data)
                    completionHandler(serializeResponse.responseObject,serializeResponse.error)
                }
                else{
                    completionHandler(nil,error)
                }
            }
            else
            {
                let serializeResponse = self.serializeResponseData(response, data: data)
                completionHandler(serializeResponse.responseObject,serializeResponse.error)
            }
        }
        
        return dataTask
    }
    
    
    func serializeResponseData(_ urlResponse:URLResponse?, data:Data?)->(responseObject:AnyObject?, error:ADError?)
    {
        if data == nil{
            return(nil,nil)
        }
        
        var responseObject:AnyObject
        
        do {
            responseObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            
            if responseObject is Dictionary<String,Any>
            {
                let metaInfo = responseObject.object(forKey: "metainfo")
                if metaInfo != nil
                {
                }
            }
        }
        catch{
            
            let error = ADError(errorDomain: ADErrorDomain.ParshingErrorDomain.rawValue, errorCode: NSURLErrorNotConnectedToInternet, localizedDescription: NSLocalizedString("parsing_error", comment:""))
            return(nil,error)
        }
        
        return (responseObject,nil);
    }
    
    func ADJSONObjectByRemovingKeysWithNullValues(_ JSONObject:AnyObject)->AnyObject
    {
        if JSONObject is Array<AnyObject>
        {
            var mutableArray:Array<AnyObject> = Array(repeating: 0, count: JSONObject.count) as Array<AnyObject>
            for value in JSONObject as! Array<AnyObject>{
                mutableArray.append(self.ADJSONObjectByRemovingKeysWithNullValues(value))
            }
            return mutableArray as AnyObject
        }
        else if JSONObject is Dictionary<String,AnyObject>
        {
            var mutableDictionary:Dictionary<String, AnyObject> = JSONObject as! Dictionary
            for key in mutableDictionary.keys
            {
                let value:AnyObject = mutableDictionary[key]!
                if value is NSNull{
                    mutableDictionary.removeValue(forKey: key)
                }
                else if value is Array<AnyObject> || value is Dictionary<String, AnyObject>
                {
                    mutableDictionary[key] = ADJSONObjectByRemovingKeysWithNullValues(value)
                }
            }
            return mutableDictionary as AnyObject
        }
        
        return JSONObject
    }
}
