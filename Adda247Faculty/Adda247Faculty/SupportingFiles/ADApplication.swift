//
//  ADApplication.swift
//  Adda247
//
//  Created by Varun Tomar on 30/03/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIApplication
{
    static var appVersionCode:String{
        if let info:Dictionary = Bundle.main.infoDictionary{
            return ""//"\(info["ApplicationVersionCode"]!)"
        }
        return ""
    }
    
    static var buildVersion: String{
        if let info:Dictionary = Bundle.main.infoDictionary{
            return "\(info["CFBundleShortVersionString"]!)"
        }
        return ""
    }
}
