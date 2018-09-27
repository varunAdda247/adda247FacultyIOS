//
//  ADTableView.swift
//  Adda247
//
//  Created by Varun Tomar on 10/09/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func takeScreenshotOfTable() -> UIImage {
        
        UIGraphicsBeginImageContext(self.contentSize)
        
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame
        
        self.contentOffset = CGPoint.zero
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
