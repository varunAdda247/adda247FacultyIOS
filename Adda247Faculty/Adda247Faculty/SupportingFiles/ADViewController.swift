//
//  ADViewController.swift
//  Adda247
//
//  Created by Varun Tomar on 04/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
private var textLabel: UILabel = UILabel()
private let effectView = UIView()

let alertToast:ADToast = ADToast()

extension UIViewController {
    
    func addBackButton()  {        
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(popCurrentViewController))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func addRightButtonWithImage(imageName:String,target: Any) {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: imageName),
                                            style: .plain,
                                            target: target as AnyObject?,
                                            action: #selector(rightBarButtonTap))
        barButtonItem.tintColor = UIColor.white
        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
        self.navigationItem.rightBarButtonItem = barButtonItem

    }

    func addTwoRightButtonsWithImage(imageName1:String,imageName2:String,target: Any) {
        let barButtonItem1 = UIBarButtonItem(image: UIImage(named: imageName1),
                                            style: .plain,
                                            target: target as AnyObject?,
                                            action: #selector(rightBarButtonTap))
        barButtonItem1.tag = 0
        let barButtonItem2 = UIBarButtonItem(image: UIImage(named: imageName2),
                                             style: .plain,
                                             target: target as AnyObject?,
                                             action: #selector(secondRightBarButtonTap))
        barButtonItem1.tintColor = UIColor.white
        barButtonItem1.tag = 1
        self.navigationItem.rightBarButtonItems = [barButtonItem1,barButtonItem2]
        
    }
    

    func addBackButtonwithTarget(target: Any)  {
        
    }
    
    
    @objc func secondRightBarButtonTap() {
        //Overrided in corresponding class
    }

    @objc func rightBarButtonTap() {
        //Overrided in corresponding class
    }
    
    @objc func popCurrentViewController(_ animated: Bool) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func showActivityIndicatorInteractionEnabledView(_ enabled:Bool) {
        
        if let indicator = self.view.subviews.last as? UIActivityIndicatorView , indicator === activityIndicator
        {
            if  activityIndicator.isAnimating {
                return
            }
            else {
                activityIndicator.startAnimating()
            }
        }
        else {
            self.view.isUserInteractionEnabled = enabled
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = UIColor.activityLoaderColor()
            activityIndicator.tag = 999
            
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            self.view.addConstraints([xConstraint, yConstraint])
            
            self.view.layoutIfNeeded()
            
            /*
             let widthConstraint = NSLayoutConstraint(item: processIndicator, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
             let heightConstraint = NSLayoutConstraint(item: processIndicator, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
             */
        }
        
    }
    
    
    func showActivityIndicatorInteractionEnabledView(_ enabled:Bool, messageText:String) {
               
        textLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        view.isUserInteractionEnabled = enabled
        
        
        effectView.frame = CGRect(x: view.frame.midX - 160/2, y: view.frame.midY - 46/2 , width: 160, height: 100)
        effectView.layer.masksToBounds = true
        effectView.backgroundColor = UIColor.clear
        
        textLabel = UILabel(frame: CGRect(x: effectView.frame.width/2-160/2, y: 50, width: 160, height: 46))
        textLabel.text = messageText
        textLabel.textAlignment = .center
        if #available(iOS 8.2, *) {
           // textLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        } else {
            // Fallback on earlier versions
            textLabel.font = UIFont(name:"Avenir", size:14)
        }
        textLabel.textColor = UIColor.black

        activityIndicator.color = UIColor.activityLoaderColor()
        activityIndicator.frame = CGRect(x: effectView.frame.width/2-46/2, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(textLabel)
        view.addSubview(effectView)
    }
    
    func hideActivityIndicatorWithMessage() {
        self.view.isUserInteractionEnabled = true
        effectView.removeFromSuperview()
    }
    
    func hideActivityIndicatorView() {
        
        if let indicator = self.view.subviews.last as? UIActivityIndicatorView , indicator === activityIndicator {
            if activityIndicator.isAnimating {
                activityIndicator.stopAnimating()
            }
            self.view.isUserInteractionEnabled = true
            activityIndicator.removeFromSuperview()
            textLabel.removeFromSuperview()
        }
    }
    
    func showAlertViewControllerWithTitle(_ title : String?, message : String?, actionButtonTitle : String, completionHandler : ((UIAlertAction) -> Void)? )
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionButtonTitle, style: .default, handler: completionHandler)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertMessage(_ message: String, alertImage image:UIImage?, alertType type:Theme, context presentationLevel:PresentationContext, duration timeDuration:Duration ) {
        //let alert = ADAlertView.viewFromNib()
        
        var alertConfig = ADAlertConfig()
        alertConfig.alertImage = image
        alertConfig.presentationContext = presentationLevel
        alertConfig.theme = type
        alertConfig.duration = timeDuration
        
        //alert.show(message, configuration: alertConfig)
        //let alertToast:ADToast = ADToast()
        //[self.childView isDescendantOfView:self.parentView]
        if(alertToast.isDescendant(of: AppDelegate.getDelegate().window!))
        {
            return
        }
        alertToast.showToast(message, configuration: alertConfig)
    }
    
    
    func checkInternetWithAlert() -> Bool {
        
        if Reachability.connectionAvailable() {
            
            return true
        }
        else
        {
            //self.showAlertMessage("NoInternet".localized, alertImage: UIImage(named: "InternetError"), alertType: .warning, context: .statusBar)
            return false
        }
    }
    
    
    func updateDeviceTokenOnServer() {
        
       
    }
    
    func openChildViewController(content: UIViewController, animate: Bool) {
        self.addChildViewController(content)
        content.view.bounds = self.view.bounds
        
        var frame = content.view.frame
        frame.origin.y = UIScreen.height
        content.view.frame = frame
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)
        if animate {
        UIView.animate(withDuration: 0.4, animations: {
            frame.origin.y = 0
            content.view.frame = frame
            self.navigationController?.isNavigationBarHidden = true
            
        }) { (isCompleted) in
            
        }
        } else {
            frame.origin.y = 0
            content.view.frame = frame
            self.navigationController?.isNavigationBarHidden = true

        }
    }
    
    func removeChildViewController(content: UIViewController, animate: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        var frame = content.view.frame
        if animate {
        UIView.animate(withDuration: 0.4, animations: {
            // content.view.alpha = 1
            frame.origin.y = UIScreen.height
            content.view.frame = frame
            
        }) { (isCompleted) in
            content.willMove(toParentViewController: nil)
            content.view.removeFromSuperview()
            content.removeFromParentViewController()
        }
        } else {
            content.willMove(toParentViewController: nil)
            content.view.removeFromSuperview()
            content.removeFromParentViewController()
        }
    }

}

