//
//  ADTableViewCell.swift
//  Adda247
//
//  Created by Varun Tomar on 09/11/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func showAlertMessage(_ message: String, alertImage image:UIImage?, alertType type:Theme, context presentationLevel:PresentationContext, duration timeDuration:Duration ) {
        
        var alertConfig = ADAlertConfig()
        alertConfig.alertImage = image
        alertConfig.presentationContext = presentationLevel
        alertConfig.theme = type
        alertConfig.duration = timeDuration
        
        if(alertToast.isDescendant(of: AppDelegate.getDelegate().window!))
        {
            return
        }
        alertToast.showToast(message, configuration: alertConfig)
    }
}
