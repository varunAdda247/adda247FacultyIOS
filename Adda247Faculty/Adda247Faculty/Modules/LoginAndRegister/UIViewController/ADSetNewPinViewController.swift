//
//  ADSetNewPinViewController.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 14/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADSetNewPinViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var confirmPinTextField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var continueBtnBottomConstraint: NSLayoutConstraint!
    var mobileNumber:String!

    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.configureInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Internal methods
    func configureInitialValues() {
        self.view.backgroundColor = UIColor.backgroundThemeColor()
        self.continueBtn.backgroundColor = UIColor.pinkThemeColor()
        self.continueBtn.setTitle("Continue", for: .normal)
    }
    
    //MARK: IBActions
    
    @IBAction func continueAction(_ sender: AnyObject){
        if (self.checkValidation()){
            //Make call to login
            self.setPinServiceCall()
        }
    }
    
    @IBAction func closeAction(_ sender: AnyObject){
        self.dismissKeyBoard()
        self.dismiss(animated: true) {
            
        }
    }
    
    func setPinServiceCall() {
        
        let suffixUrl = "\(APIURLSuffix.setPin)"
        //?mobile=\(mobileNumber!)&pin=\(self.pinTextField.text!)
        let tempPara:NSMutableDictionary = NSMutableDictionary()
        
        tempPara.setObject(mobileNumber!, forKey: "mobile" as NSCopying)
        tempPara.setObject(self.pinTextField.text!, forKey: "pin" as NSCopying)
        
        _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: tempPara, success: { (response) in
            print(response)
            if let response = response as? Dictionary<String,Any>{
                if let data = response["data"] as? Dictionary<String,Any>{
                    
                    if let name = data["facultyName"] as? String{
                        //Update faculty name
                        ADUtility.updateFacultyName(name: name)
                    }
                    
                    if let facultyId = data["facultyId"] as? NSNumber{
                        //Update token
                        ADUtility.updateFacultyId(id: facultyId.stringValue)
                    }
                    
                    //Open home view conntroller
                    DispatchQueue.main.async(execute: {
                        self.openHomeViewController()
                    })
                }
                
                if let message = response["message"] as? String{
                    print(message)
                }
                DispatchQueue.main.async(execute: {
                    self.hideActivityIndicatorView()
                })
                
            }
            
            DispatchQueue.main.async(execute: {
                self.hideActivityIndicatorView()
            })
            
        }) { (error) in
            DispatchQueue.main.async(execute: {
                self.hideActivityIndicatorView()
                self.showAlertMessage("Please check your internet connection", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            })
        }
        
    }
    
    func checkValidation() -> Bool {
        if (self.pinTextField.text?.isBlank)! {
            self.showAlertMessage("Please enter PIN", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        if (self.confirmPinTextField.text?.isBlank)! {
            self.showAlertMessage("Please enter confirm PIN", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if false == (self.pinTextField.text?.isPhoneNumberValid())!{
            self.showAlertMessage("PIN is not valid", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if false == (self.confirmPinTextField.text?.isPhoneNumberValid())!{
            self.showAlertMessage("Confirm PIN is not valid", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if ((self.confirmPinTextField.text)! != (self.pinTextField.text)!){
            self.showAlertMessage("Confirm PIN doesn't match", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        return true
    }
    
    func openHomeViewController() {
        let controller:ADHomeViewController = UIStoryboard.instantiateController(forModule: ADStoryModule.main)
        //        self.navigationController?.pushViewController(controller, animated: true)
        
        let navigationController = UINavigationController(rootViewController: controller)
        
        let appDelegate = AppDelegate.getDelegate()
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction( name:kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        CATransaction.begin()
        appDelegate.window?.layer.add(transition, forKey: nil)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        CATransaction.commit()
    }
    
    func dismissKeyBoard() {
        self.pinTextField.resignFirstResponder()
    }
    
    //MARK : Textfield delegate
    //MARK : Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        // Do not add a line break
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= ADUtility.pinLength
    }
    
    //MARK : Keyboard Notification
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.height
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.continueBtnBottomConstraint.constant = height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.continueBtnBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}
