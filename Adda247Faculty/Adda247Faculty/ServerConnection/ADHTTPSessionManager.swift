//
//  ADHTTPSessionManager.swift
//  Adda247
//
//  Created by Varun Tomar on 05/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

class ADHTTPSessionManager: ADURLSessionManager{
    
    init(withBaseURL url: String) {
        super.init(withConfiguration: nil)
        self.baseURL = url
    }
    
    init(configure:URLSessionConfiguration?)
    {
        super.init(withConfiguration: configure)
    }
    
    func GET(appbBaseUrl:String, suffixUrl:String, parameters:Any?, success:@escaping (_ response:Any?)->Void,failure:@escaping (_ error:ADError)->Void)->URLSessionDataTask?
    {
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: UserKeyConstants.token) as? String
        if(token != nil && (token?.count)! > 0){//token!
            self.HTTPRequestHeaders = ["X-Auth-Token":"fpoa43edty5","Content-Type":"application/json","X-JWT-Token":token!,"User-Agent":"ios","osVersion":UIDevice.OSVersion,"appVersion":String(describing: Bundle.main.releaseVersionNumber!),"cp-origin":"8","build":String(describing: Bundle.main.buildVersionNumber!)]
        }
        else{
            self.HTTPRequestHeaders = ["X-Auth-Token":"fpoa43edty5","Content-Type":"application/json","User-Agent":"ios","OSVersion":UIDevice.OSVersion,"appVersion":String(describing: Bundle.main.releaseVersionNumber!),"cp-origin":"8","build":String(describing: Bundle.main.buildVersionNumber!)]
        }
        self.contentType = "application/json"
        
        let dataTask:URLSessionDataTask? = self.dataTaskWithHTTPMethod("GET", url: suffixUrl, parameters: parameters,baseUrl:appbBaseUrl, success: success, failure: failure)
        
        guard let task = dataTask else{
            return nil
        }
        
        task.resume()
        return task
    }
    
    func POST(appbBaseUrl:String, suffixUrl:String, parameters:Any?, success:@escaping (_ response:Any?)->Void,failure:@escaping (_ error:ADError)->Void)->URLSessionDataTask?
    {
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: UserKeyConstants.token) as? String
        if(token != nil && (token?.count)! > 0){//token!
            self.HTTPRequestHeaders = ["X-Auth-Token":"fpoa43edty5","Content-Type":"application/json","Token":token!,"User-Agent":"ios","osVersion":UIDevice.OSVersion,"appVersion":String(describing: Bundle.main.releaseVersionNumber!),"cp-origin":"8","build":String(describing: Bundle.main.buildVersionNumber!)]
        }
        else{
            self.HTTPRequestHeaders = ["X-Auth-Token":"fpoa43edty5","Content-Type":"application/json","User-Agent":"ios","osVersion":UIDevice.OSVersion,"appVersion":String(describing: Bundle.main.releaseVersionNumber!),"cp-origin":"8","build":String(describing: Bundle.main.buildVersionNumber!)]
        }
        self.contentType = "application/json"
        
        print("Request Header : \(self.HTTPRequestHeaders)")
        
        let dataTask:URLSessionDataTask? = self.dataTaskWithHTTPMethod("POST", url: suffixUrl, parameters: parameters,baseUrl:appbBaseUrl, success: success, failure: failure)
        
        guard let task = dataTask else{
            return nil
        }
        
        task.resume()
        return task
    }
    
    func dataTaskWithHTTPMethod(_ method:String,url:String, parameters:Any?,baseUrl:String?, success:@escaping (_ response:Any?)->Void,failure:@escaping (_ error:ADError)->Void)->URLSessionDataTask?
    {
        let urlString:String
        if let baseUrlUnraped = baseUrl
        {
            urlString = "\(baseUrlUnraped)\(url)"
        }
        else
        {
            urlString = "\(baseUrl!)/\(url)"
        }
        print("*****API Url******* : \(urlString)")
        
        var requestTuple  = self.requestWithMethod(method, urlString: urlString, parameters: parameters)

        //Unwrapped parameters value
        if let unwrappedParams = parameters {
            if(method != "GET"){
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: unwrappedParams,
                    options: [.prettyPrinted]) {
                    let theJSONText = String(data: theJSONData,
                                             encoding: .ascii)
                    if let jsonText = theJSONText {
                        print("*****Params******* :\(jsonText)")
                        requestTuple  = self.requestWithMethod(method, urlString: urlString, parameters: jsonText)
                    }
                }
            }
        }
        else{
            requestTuple  = self.requestWithMethod(method, urlString: urlString, parameters: parameters)
        }
        
        
        if let _ = requestTuple.error//NSLocale
        {
            return nil
        }
        
        
        let dataTask:URLSessionDataTask = self.dataTaskWithRequest(requestTuple.request) { (responseData, error) -> Void in
            
            if let error = error{
                failure(error)
            }
            else if let response = responseData{
                //RESPONSE 
               print("*****API Response***** : \(response)")
                success(response)
            }
            else{
                
                let error = ADError(errorDomain: ADErrorDomain.NetworkErrorDomain.rawValue, errorCode: NSURLErrorNotConnectedToInternet, localizedDescription: NSLocalizedString("serivce_not_available", comment:""))
                failure(error)
            }
        }
        
        return dataTask
    }
    
    func requestWithMethod(_ method:String, urlString:String, parameters:Any?)->(request:URLRequest,error:ADError?)
    {
        let url:URL = URL(string:urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(self.contentType, forHTTPHeaderField:"Content-Type")
        request.httpShouldHandleCookies = false
        for (key, value) in self.HTTPRequestHeaders
        {
            request.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        self.serializeRequest(&request, parameters: parameters, method: method)
        return (request,nil)
    }
    
    func serializeRequest( _ request:inout URLRequest,parameters:Any?,method:String)
    {
        if let params = parameters
        {
            var paramString : String? = ""
            
            if( params is Dictionary<NSString, AnyObject>)
            {
                for(key, value) in params as! Dictionary<String, AnyObject>
                {
                    let paramStr = "&\(key)=\(value)"
                    paramString = paramString! + paramStr
                }
            }
            else
            {
                paramString = params as? String
            }
            
            if method == "POST"
            {
                var paramData:Data?
                if params is Array<AnyObject>
                {
                    do
                    {
                        paramData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let str:String = "dataArray"
                        let mutableData:NSMutableData = (str.data(using: String.Encoding.utf8)! as NSData).mutableCopy() as! NSMutableData
                        mutableData.append(paramData!)
                        paramData = mutableData as Data;
                    }
                    catch
                    {
                        
                    }
                }
                else
                {
                    paramData = paramString?.data(using: String.Encoding.ascii)
                }
                
                request.setValue("\((paramData?.count)!)", forHTTPHeaderField:"Content-Length")
                request.httpBody = paramData
            }
            else if let paramStringUn = paramString , !paramStringUn.isEmpty
            {
                let urlString:String = "\(request.url!.absoluteString)?\(paramStringUn)"
                request.url = URL(string:urlString)
            }
        }
    }
}

import UIKit

// MARK: - Image downloading utility
extension ADHTTPSessionManager {
    class func fetchImage(_ url: URL, completionHandler:@escaping (UIImage?) -> Void) {
        let defaultSessionConfig = URLSessionConfiguration.default
        let sessionManager = URLSession(configuration: defaultSessionConfig)
        let dataTask = sessionManager.dataTask(with: url) { (data, response, error) in
            
            if let imageData = data , error == nil {
                
                if let image = UIImage(data: imageData) {
                    
                    DispatchQueue.main.async(execute: {
                        completionHandler(image)
                    })
                    return
                }
            }
            DispatchQueue.main.async(execute: {
                completionHandler(nil)
            })
        }
        
        return dataTask.resume()
        
    }
}
