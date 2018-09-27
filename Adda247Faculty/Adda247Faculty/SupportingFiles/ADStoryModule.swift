//
//  ADStoryModule.swift
//  Adda247
//
//  Created by Varun Tomar on 03/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

/**
 Enum for storyboard modules.
 - note: Make sure, rawValue of the enum case corresponds to a storyboard's name
 */
enum ADStoryModule : String {
    case splash = "Splash"
    case loginAndRegistration = "LoginAndRegistration"
    case main = "Main"
    case settings = "Settings"
}

extension UIStoryboard {
    /**
     Intantiate a view controller form given storyboard case.
     - parameter module: Module name case
     - returns: A view controller instantiated from modules storyobard.
     */
    class func instantiateController<T>(forModule module : ADStoryModule) -> T {
        let storyboard = UIStoryboard.init(name: module.rawValue, bundle: nil);
        let name = String(describing: T.self).components(separatedBy: ".").last
        return storyboard.instantiateViewController(withIdentifier: name!) as! T
    }
    
    /**
     Intantiate a view controller form given storyboard case.
     - parameter module: Module name case
     - parameter storyboardId: ViewController storyboard id
     - returns: A view controller instantiated from modules storyobard.
     */
    class func instantiateController<T>(forModule module : ADStoryModule,
                                     withStoryboardId storyboardId:String) -> T {
        let storyboard = UIStoryboard.init(name: module.rawValue, bundle: nil);
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
            as! T
    }
}
