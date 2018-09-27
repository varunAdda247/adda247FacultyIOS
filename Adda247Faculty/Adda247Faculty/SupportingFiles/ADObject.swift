//
//  ADObject.swift
//  Adda247
//
//  Created by Varun Tomar on 04/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

extension NSObject
{
    var className:String{
        return String(describing: type(of:self))//.components(separatedBy: ".").last!
    }
    
    public class func NNClassFromString(_ className: String) -> AnyClass! {
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let fAppName = appName.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
            return NSClassFromString("\(fAppName).\(className)")
        }
        return nil;
    }
}
