//
//  ADEnterMobileNumberViewController.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 13/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADEnterMobileNumberViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var continueBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var phoneNumberLength = 10
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
        self.continueBtn.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
    }
    
    @IBAction func continueAction(_ sender: AnyObject){
        
        if (self.checkValidation()){
            print("Validation successfull")
            //Make server call to check number registration
            let params:NSMutableDictionary = NSMutableDictionary()
            params.setObject(self.mobileNumberTextField.text!, forKey: "mobile" as NSCopying)
            
           let suffixUrl = "\(APIURLSuffix.phoneNumberVerification)?mobile=\(self.mobileNumberTextField.text!)"

           self.showDataLoadingMessage()
            
           _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: params, success: { (response) in
            print(response)
            if let response = response as? Dictionary<String,Any>{
                if let success = response["success"] as? NSNumber{
                    print(success)
                    if(success == 0){
                        //Faculty is not on ERP
                        
                    }
                    else if(success == 1){
                        //Faculty is on ERP and have loged in before so just open login screen from here
                        DispatchQueue.main.async(execute: {
                            self.openLoginController()
                        })
                    }
                    else if(success == 2){
                        //Faculty is on ERP but loging first time, now needs to pass through OTP screen
                        DispatchQueue.main.async(execute: {
                            self.openLoginController()
                        })
                        
                    }
                }
                
                if let message = response["message"] as? String{
                    DispatchQueue.main.async(execute: {
                        //self.hideActivityIndicatorView()
                       // self.stopDataLoadingMessage()
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.messageLbl.isHidden = false
                        self.messageLbl.text = message
                    })
                    
                }
            }
           
            DispatchQueue.main.async(execute: {
                //self.hideActivityIndicatorView()
                //self.stopDataLoadingMessage()
            })
                
            }) { (error) in
                DispatchQueue.main.async(execute: {//Subjects3Shreya8130710060qwert
                    self.stopDataLoadingMessage()
                    self.messageLbl.text = ""
                    self.showAlertMessage("Please check your internet connection", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                })
            }
        }
    }
    
    func openLoginController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:ADLoginViewConntroller = storyboard.instantiateViewController(withIdentifier: "ADLoginViewConntroller") as! ADLoginViewConntroller
        controller.mobileNumber = self.mobileNumberTextField.text!
        self.present(controller, animated: true) {
            
        }
    }
    
    func openOtpController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:ADLoginViewConntroller = storyboard.instantiateViewController(withIdentifier: "ADLoginViewConntroller") as! ADLoginViewConntroller
        controller.mobileNumber = self.mobileNumberTextField.text!
        self.present(controller, animated: true) {
            
        }
    }

    
    func showDataLoadingMessage() {
        self.messageLbl.isHidden = false
        self.messageLbl.text = "Checking your mobile number..."
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopDataLoadingMessage() {
        //self.messageLbl.isHidden = true
        self.messageLbl.text = "Checking your mobile number..."
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func closeAction(_ sender: AnyObject){
        self.dismissKeyBoard()
        self.dismiss(animated: true) {
            
        }
    }
    
    func checkValidation() -> Bool {
        if (self.mobileNumberTextField.text?.isBlank)! {
            self.showAlertMessage("Please enter your registered phone number", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if false == (self.mobileNumberTextField.text?.isPhoneNumberValid())!{
            self.showAlertMessage("Phone number is not valid", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        return true
    }
    
    func dismissKeyBoard() {
        self.mobileNumberTextField.resignFirstResponder()
    }
    
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
        
        return updatedText.count <= phoneNumberLength
    }

    
    //MARK : Keyboard Notification
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if(iPhone4or4S || iPhone5or5S){
//                self.loginBtn.isHidden = true
//            }
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
//            if(iPhone4or4S || iPhone5or5S){
//                self.loginBtn.isHidden = false
//            }
        })
    }
}
