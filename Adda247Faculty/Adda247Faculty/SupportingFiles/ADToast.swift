//
//  ADToast.swift
//  Adda247
//
//  Created by Varun Tomar on 20/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

//let label = ADInsetLabel(frame: CGRect.zero)

class ADToast : UILabel
{
    let topInset = CGFloat(5)
    let bottomInset = CGFloat(5)
    let leftInset = CGFloat(12)
    let rightInset = CGFloat(12)
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        self.hideAlertView()
    }
    
    
    func hideAlertView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            self.superview?.layoutSubviews()
            
        }, completion: {(finished: Bool) in
            
            self.removeFromSuperview()
        })
    }

   
    // function which is triggered when handleTap is called
    func handleTap() {
        UIView.animate(withDuration:2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.alpha = 0
        },  completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
    }
    
    func showToast(_ message:String, configuration config:ADAlertConfig){
        showAlert(message: message, configuration: config)
    }
    
    //MARK : Private functions
    private func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 320.0))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        var height:CGFloat = label.frame.height + 10.0
        //Here set minimum height of toast
        if(height < 50.0){
            height = 50.0
        }
        return height
    }
    
    func showAlertFromBottom( message:String, configuration config:ADAlertConfig){
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.textAlignment = NSTextAlignment.center
        self.text = message
        self.font = UIFont(name: "Avenir-Book", size: 14)
        self.adjustsFontSizeToFitWidth = true
        self.isUserInteractionEnabled = true
        
        self.backgroundColor =  config.theme.backgroundColor() //UIColor.whiteColor()
        self.textColor = config.theme.textColor() //TEXT COLOR
        
        self.sizeToFit()
        self.numberOfLines = 0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 3)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
//        let attachment = NSTextAttachment()
//        attachment.image = UIImage(named: "correctOptionIcon")
//        attachment.bounds = CGRect(x: 0, y: 0, width: 28, height: 28)
//        let attachmentStr = NSAttributedString(attachment: attachment)
//        let myString = NSMutableAttributedString(string: " ")
//        myString.append(attachmentStr)
//        let myString1 = NSMutableAttributedString(string: message)
//        myString.append(myString1)
//        self.attributedText = myString
        
        
        self.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height), width: appDelegate.window!.frame.size.width, height: 60.0)
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath

        self.alpha = 1
        
        appDelegate.window!.addSubview(self)
        
        var basketTopFrame: CGRect = self.frame;
        basketTopFrame.origin.y = (UIScreen.main.bounds.height)
        
       
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            basketTopFrame.origin.y = (UIScreen.main.bounds.height - 60)
            self.frame = basketTopFrame
            
        }) { (value) in
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.frame = basketTopFrame
            }) { (value: Bool) in
                UIView.animate(withDuration: 0.3, delay: config.duration.visibilityDuration(), options: UIViewAnimationOptions.curveEaseIn, animations: {
                    basketTopFrame.origin.y = (UIScreen.main.bounds.height + 60)
                    self.frame = basketTopFrame
                }) { (value: Bool) in
                    self.removeFromSuperview()
                }
            }
        }
        
    }
    
    private func showAlert( message:String, configuration config:ADAlertConfig)
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.textAlignment = NSTextAlignment.center
        self.text = message
        self.font = UIFont(name: "Avenir-Book", size: 14)
        self.adjustsFontSizeToFitWidth = true
        self.isUserInteractionEnabled = true
        
        self.backgroundColor =  config.theme.backgroundColor() //UIColor.whiteColor()
        self.textColor = config.theme.textColor() //TEXT COLOR
        
        self.sizeToFit()
        self.numberOfLines = 0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 3)
        self.layer.shadowOpacity = 0.3
        self.frame = CGRect(x: 0, y: -heightForView(text: message, font: self.font, width: appDelegate.window!.frame.size.width), width: appDelegate.window!.frame.size.width, height: heightForView(text: message, font: self.font, width: appDelegate.window!.frame.size.width))
        
        self.alpha = 1
        
        appDelegate.window!.addSubview(self)
        
        var basketTopFrame: CGRect = self.frame;
        basketTopFrame.origin.y = config.presentationContext.topOffset();
        
//        UIView.animate(withDuration
//            :1, delay: 0.0, usingSpringWithDamping:0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
//                self.frame = basketTopFrame
//        },  completion: {
//            (value: Bool) in
//            UIView.animate(withDuration:1, delay: config.duration.visibilityDuration(), usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
//                basketTopFrame.origin.y = -(self.heightForView(text: message, font: self.font, width: appDelegate.window!.frame.size.width + 5))
//                self.frame = basketTopFrame
//                //self.alpha = 0
//            },  completion: {
//                (value: Bool) in
//                self.removeFromSuperview()
//            })
//        })
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.frame = basketTopFrame
        }) { (value: Bool) in
            UIView.animate(withDuration: 0.3, delay: config.duration.visibilityDuration(), options: UIViewAnimationOptions.curveEaseIn, animations: {
                basketTopFrame.origin.y = -(self.heightForView(text: message, font: self.font, width: appDelegate.window!.frame.size.width + 5))
                self.frame = basketTopFrame
            }) { (value: Bool) in
                self.removeFromSuperview()
            }
        }
        
        
    }
    
}
