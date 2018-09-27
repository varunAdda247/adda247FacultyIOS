//
//  ADViewController.swift
//  Adda247
//
//  Created by Varun Tomar on 04/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

var alertHorizontalOffset = 10

class ADAlertView: UIView {

    //@IBOutlet weak var alertImageView: UIImageView!
    
    @IBOutlet weak var alertDescriptionLabel: UILabel!

    
    var topOffset: CGFloat = 0.0
    var visibilityDuration: Double = 2.2
    var interactiveHide: Bool = true
    
    
    public static func viewFromNib(filesOwner: AnyObject = NSNull.init()) -> ADAlertView {
        
         let arrayOfViews = Bundle.main.loadNibNamed("ADAlertView", owner: filesOwner, options: nil) ?? []
        return arrayOfViews.flatMap( { $0 as? ADAlertView} ).first!
    }
    
    
    
    private func configureAlert(_ config: ADAlertConfig) {
        
        self.backgroundColor = config.theme.backgroundColor()
        self.alertDescriptionLabel.textColor = config.theme.textColor()
        
        self.topOffset = config.presentationContext.topOffset()
        self.visibilityDuration = config.duration.visibilityDuration()
        self.interactiveHide = config.interactiveHide
        alertHorizontalOffset = (config.presentationContext == .window) ? 0:10
        self.layer.cornerRadius = (config.presentationContext == .window) ? 0:5
        
//        if let image = config.alertImage
//        {
//         
//            self.alertImageView.image = image
//        }
//        else
//        {
//            self.alertImageView.removeFromSuperview()
//        }
    }
    
    
    func show(_ message:String, configuration config:ADAlertConfig) {
        
        self.configureAlert(config)
        self.alertDescriptionLabel.text = message
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        
        window?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(alertHorizontalOffset)-[view]-\(alertHorizontalOffset)-|", options:
            NSLayoutFormatOptions(), metrics: nil, views: ["view":self]))
        
        let topConstraint = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1.0, constant: self.topOffset)
        window?.addConstraint(topConstraint)
        
        self.layoutSubviews()
        
        
        let estimatedSize:CGSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        topConstraint.constant = self.topOffset - estimatedSize.height
        window?.layoutSubviews()
        
        topConstraint.constant = self.topOffset
        self.alpha = 0.0
        self.backgroundColor = UIColor.red
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            window?.layoutSubviews()
            
        }, completion: {(finished: Bool) in
            
            self.perform(#selector(self.hideAlertView), with: nil, afterDelay: self.visibilityDuration)
        })
    }
    
    
    @objc func hideAlertView() {
     
        UIView.animate(withDuration: 0.3, animations: {
            
            self.alpha = 0.0
            self.superview?.layoutSubviews()
            
        }, completion: {(finished: Bool) in
            
            self.removeFromSuperview()
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if self.interactiveHide {
            self.hideAlertView()
        }
    }
}



/// The theme enum specifies the built-in theme options
public enum Theme {
    case info
    case success
    case warning
    case error
    
    func backgroundColor() -> UIColor {
        
        switch self {
        case .info:
            return UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)
            
        case .success:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
        case .warning:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
        case .error:
            return UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        }
    }
    
    func textColor() -> UIColor {
        
        switch self {
        case .info:
            return UIColor.darkText
            
        case .success, .warning, .error:
            return UIColor.black
        }
    }
}



/**
 Specifies how the container for presenting the alert view
 is selected.
 */
public enum PresentationContext {
    case window
    case statusBar
    case navigationBar
    case center
    case below
    
    
    func topOffset() -> CGFloat {
        switch self {
        case .window:
            return 0
            
        case .statusBar:
            return 20
            
        case .navigationBar:
            return 64
            
        case .center:
            return UIScreen.main.bounds.height/2
            
        case .below:
            return UIScreen.main.bounds.height-44
        }
        
        
    }
}



/**
 Specifies the duration of the alert view's time on screen before it is
 automatically hidden.
 */
public enum Duration {
    
    /**
     Hide the alert view after the default duration.
     */
    case automatic
    
    /**
     Disables automatic hiding of the alert view.
     */
    case forever
    
    /**
     Hide the alert view after the speficied number of seconds.
     
     - Parameter seconds: The number of seconds.
     */
    case seconds(seconds: TimeInterval)
    
    func visibilityDuration() -> TimeInterval {
       
        switch self {
        case .automatic:
            return 3
            
        case .forever:
            return Double.infinity
            
        case .seconds(let time):
            return time
        }
    }
}


public struct ADAlertConfig {
    
    public init() {}
    
    public var theme = Theme.warning
    
    /**
     Specifies how the container for presenting the alert view
     is selected. The default is `.window`.
     */
    public var presentationContext = PresentationContext.window
    
    /**
     Specifies the duration of the alert view's time on screen before it is
     automatically hidden. The default is `.Automatic`.
     */
    public var duration = Duration.automatic
    
    /**
     Specifies whether or not the interactive pan-to-hide gesture is enabled
     on the alert view. The default is `true`.
     */
    public var interactiveHide = true
    
    public var alertImage: UIImage?
}
