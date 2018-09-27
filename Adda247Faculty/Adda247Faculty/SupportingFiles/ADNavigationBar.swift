//
//  ADNavigationBar.swift
//  Adda247
//
//  Created by Varun Tomar on 04/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    
    public func hideBottomHairLine() {
        let navBarHairlineImageView = findHairlineImageViewUnder(self)
        navBarHairlineImageView?.isHidden = true
    }
    
    public func showBottomHairLine() {
        let navBarHairlineImageView = findHairlineImageViewUnder(self)
        navBarHairlineImageView?.isHidden = false
    }
    
    public func makeTransparent() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        backgroundColor = UIColor.clear
        shadowImage = UIImage()
        hideBottomHairLine()
    }
    
    public func defaultSettings(){
        self.tintColor = UIColor.white
        self.barTintColor = UIColor.navigationBarColor()
        self.titleTextAttributes = [kCTFontAttributeName: UIFont.navigationBarFont(),kCTForegroundColorAttributeName: UIColor.white] as [NSAttributedStringKey : Any]
    }
    
    public func makeDefault() {
        isTranslucent = true
        setBackgroundImage(nil,for: .default)
        backgroundColor = nil
        shadowImage = nil
        showBottomHairLine()
    }
    
    // MARK: Private Functions
    fileprivate func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if let view = view as? UIImageView , view.bounds.height <= CGFloat(1.0) {
            return view
        }
        for subview in view.subviews {
            if let imageView = findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
    
    func barColor(_ color: UIColor) {
        
        self.barTintColor = color
    }
}
