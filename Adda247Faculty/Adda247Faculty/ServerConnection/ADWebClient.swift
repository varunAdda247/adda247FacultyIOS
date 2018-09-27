//
//  ADWebClient.swift
//  Adda247
//
//  Created by Varun Tomar on 05/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

import UIKit

//Only for Release mode
let appServerURL  = "https://api.adda247.com/"


//Only for Debug mode
let rootURL = "https://stagingapi.adda247.com/"

var appRootURL: String{
    #if DEBUG
        return appServerURL
    #else
        return appServerURL
    #endif
}


class ADWebClient: ADHTTPSessionManager
    {
    static let sharedClient = ADWebClient(configure: nil)
        fileprivate override init(configure configuration:URLSessionConfiguration?){
            super.init(configure: configuration)
        //self.HTTPRequestHeaders = ["Platform":"ios","OSVersion":UIDevice.OSVersion,"AppVersionCode":UIApplication.appVersionCode]
        //"X-JWT-Token":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkZXZvcHNAZ21haWwuY29tIn0.r-ty2_5a2f8CGn0137sy7uW1sSD82UFkPk_w52IEe3wCNeQsGP7yWB0azHIJhcfZokuOkipOJAgB0i2NRb6CDw"

        }
    }
