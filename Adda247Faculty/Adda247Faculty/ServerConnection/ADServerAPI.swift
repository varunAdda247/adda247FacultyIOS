//
//  ADServerAPI.swift
//  Adda247
//
//  Created by Varun Tomar on 30/03/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import Alamofire

let serverURL = "https://stagingapi.adda247.com/"
//
enum ADServerAPI : URLRequestConvertible{
    
    var baseURLString:String{
        
        switch self {
            
        default:
            return serverURL
        }
    }
    
    //Current affairs
    case fetchCurrentAffairsList(authToken:String,jwtToken:String, contentType:String)
    
    //Users
    case login(username:String,password:String)
    case logOut(userID:String)
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .fetchCurrentAffairsList:
                return .get
            case .logOut,.login:
                return .post
            default:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .fetchCurrentAffairsList(let authToken, let jwtToken, let contentType):
                return ["X-Auth-Token":authToken,"X-JWT-Token":jwtToken,"Content-Type":contentType]
                
            default:
                return nil
            }
        }()
        
        let url:URL = {
            let relativePath:String?
            switch self {
            case .fetchCurrentAffairsList:
                relativePath = "currentaffairs/list?language=HINDI"
            
            default:
                relativePath = ""
            }
        
            var urlString =  baseURLString
            if let relativePath = relativePath {
                urlString = "\(urlString)/\(relativePath)"
            }
            return URL(string: urlString)!
        }()
        
        //URL Creation
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = ["Platform":"ios","OSVersion":UIDevice.OSVersion,"AppVersionCode":UIApplication.appVersionCode]
        
        let encoding = URLEncoding.queryString
        return try encoding.encode(urlRequest, with: params)
    }

}
