//
//  ADConstants.swift
//  Adda247
//
//  Created by Varun Tomar on 31/03/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

//MARK : Device Screen
/********************************** DEVICE SCREEN ******************************************/

let iPhone4or4S:Bool = Double(UIScreen.main.bounds.size.height) - Double(480) < Double.ulpOfOne
let iPhone5or5S:Bool = Double(UIScreen.main.bounds.size.height) - Double(568) < Double.ulpOfOne
let iPhone6or7:Bool = Double(UIScreen.main.bounds.size.height) - Double(667) < Double.ulpOfOne
let iPhone6SPlusOr7SPlus:Bool = Double(UIScreen.main.bounds.size.height) - Double(736) < Double.ulpOfOne


//MARK : Result Blocks
//*********************************** RESULT BLOCKS *****************************************
typealias ADResponseBlock = (_ responseObject:Any?,_ error:ADError?)->Void

typealias ADBooleanResponseBlock = (_ succeeded:Bool,_ error:ADError?)->Void

typealias ADDualResponseBlock = (_ firstResponse:Any?,_ secondResponse:Any?,_ error:ADError?)->Void

typealias ADBooleanWithMessageResponseBlock = (_ succeeded:Bool,_ message:String)->Void

//MARK : Error Domain
//*********************************** ERROR DOMAIN *****************************************
enum ADErrorDomain: String{
    case NetworkErrorDomain     = "com.adda247.domain.networkError"
    case ParshingErrorDomain    = "com.adda247.domain.parsingError"
    case URLResponseErrorDomain = "com.adda247.error.response"
    
}

//MARK : Profile
//********************************** PROFILE ****************************************
//let google_client_id = "117575776360-se3ubakrmij2q5mouk2rk46740ipurca.apps.googleusercontent.com"


struct CurrentAffairsParamKeys {
    static let updatedAt = "updatedAt"
    static let size = "size"
    static let isForward = "isForward"
    static let category = "category"
    static let language = "language"
    static let examId = "examId"
    static let subject = "subject"
}


struct ErrorMessages {
    static let internetNotAvailable = "Internet is not available";
   }



struct UserKeyConstants {
    //Login
    static let facultyName = "facultyName"
    static let facultyId = "facultyId"
    static let token = "token"
    static let jwtToekn = "jwtToken"
}



enum LanguageConstants {
    static let englishLangCode = "en"
    static let hindiLangCode = "hi"
}
