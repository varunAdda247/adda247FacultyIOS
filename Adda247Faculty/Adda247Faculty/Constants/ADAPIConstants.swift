//
//  ADAPIConstants.swift
//  Adda247
//
//  Created by Varun Tomar on 19/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

struct APIURLSuffix {
    static let phoneNumberVerification = "faculty/verification"
    static let login = "faculty/login"
    static let getClasses = "faculty/classes"
    static let resendOtp = "/faculty/otp"
    static let setPin = "faculty/app/registration"

}

struct APIURL {
    
    //PROD
    //static let baseUrl = "https://erp.adda247.com/user/"
    
    //TEST
    static let baseUrl = "http://erp-stag.adda247.com/user/"
    
}

