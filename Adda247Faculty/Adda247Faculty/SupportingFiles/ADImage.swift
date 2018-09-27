//
//  ADImage.swift
//  Adda247
//
//  Created by Varun Tomar on 31/03/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit
import Foundation

extension UIImage
{
    static var launchImage: UIImage?{
        get {

            if iPhone4or4S{
                return UIImage(named: "LaunchImage-700@2x.png")
            }
            else if iPhone5or5S{
                return UIImage(named: "LaunchImage-700-568h@2x.png")
            }
            else if iPhone6or7{
                return UIImage(named: "LaunchImage-800-667h@2x.png")
            }
            else if iPhone6SPlusOr7SPlus{
                return UIImage(named: "LaunchImage-800-Portrait-736h@3x.png")
            }
            return nil
        }
    }
}
