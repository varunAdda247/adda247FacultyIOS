//
//  ADLoginViewConntroller.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 12/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADLoginWithEmailViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginUsingEmailLbl: UILabel!
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var loginBtnBottomConstraint: NSLayoutConstraint!
    
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
        self.loginBtn.backgroundColor = UIColor.pinkThemeColor()
        
        self.loginUsingEmailLbl.text = NSLocalizedString("login_using_email", comment: "")
        self.emailTextField.placeholder = NSLocalizedString("email", comment: "")
        self.passwordTextField.placeholder = NSLocalizedString("password", comment: "")
        self.forgotBtn.setTitle(NSLocalizedString("forgot_with_quetion_mark", comment: ""), for: .normal)
        self.loginBtn.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        self.registerBtn.setTitle(NSLocalizedString("new_to_adda247_register", comment: ""), for: .normal)
        //login new_to_adda247_register
    }
    
    //MARK: IBActions
    @IBAction func forgotPasswordAction(_ sender: AnyObject){
        if (self.emailTextField.text?.isBlank)! {
            self.showAlertMessage(NSLocalizedString("please_enter_register_email_id", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return
        }
        else if false == (self.emailTextField.text?.isEmailValid(enteredEmail: self.emailTextField.text!))!{
            self.showAlertMessage("Email is not valid", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return
        }
        
        self.dismissKeyBoard()
        
        if Reachability.connectionAvailable() {
            let params:NSMutableDictionary = NSMutableDictionary()
            params.setObject(self.emailTextField.text!, forKey: ParamKeys.emailId as NSCopying)
            
            self.showActivityIndicatorInteractionEnabledView(true)
            
            //Service Call for forgot password
            _ = ADWebClient.sharedClient.GET(appbBaseUrl: APIURL.baseUserUrl, suffixUrl: APIURLSuffix.forgotPassword, parameters: params, success: { (response) in
                DispatchQueue.main.async(execute: {
                    self.hideActivityIndicatorView()
                    let storyboard = UIStoryboard(name: "LoginAndRegistration", bundle: nil)
                    let controller:ADForgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ADForgotPasswordViewController") as! ADForgotPasswordViewController
                    controller.emailAddress = self.emailTextField.text
                    
                    self.present(controller, animated: true, completion: {
                        self.showAlertMessage("OTP sent successfully", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                    })
                    
                })
                
            }) { (error) in
                DispatchQueue.main.async(execute: {
                    self.hideActivityIndicatorView()
                })
            }
        }
        else{
            self.showAlertMessage(NSLocalizedString("no_internet_connection", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            
        }
        
    }
    
    @IBAction func registerUserAction(_ sender: AnyObject){
        let storyboard = UIStoryboard(name: "LoginAndRegistration", bundle: nil)
        let controller:ADRegistrationViewController = storyboard.instantiateViewController(withIdentifier: "ADRegistrationViewController") as! ADRegistrationViewController
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func loginAction(_ sender: AnyObject){
        if (self.checkValidation()){
            
            if Reachability.connectionAvailable(){
                self.dismissKeyBoard()
                let params:NSMutableDictionary = NSMutableDictionary()
                params.setObject(self.emailTextField.text!, forKey: ParamKeys.email as NSCopying)
                params.setObject(self.passwordTextField.text!, forKey: ParamKeys.sec as NSCopying)
                params.setObject(Register.providerNameEmail, forKey: ParamKeys.providerName as NSCopying)
                
                self.showActivityIndicatorInteractionEnabledView(true)
                
                _ = ADWebClient.sharedClient.POST(appbBaseUrl:APIURL.baseUserUrl, suffixUrl: APIURLSuffix.login, parameters: params, success: { (response) in
                    
                    DispatchQueue.main.async(execute: {
                        self.hideActivityIndicatorView()
                        //Parse response
                        if let unwrapped = response {
                            
                            //Save user info in defaults
                            let tempDic:NSDictionary = unwrapped as! NSDictionary
                            
                            if let statusCode = tempDic.value(forKey: "status"){
                                if(String(describing: statusCode) == "400"){
                                    if let errorMessage = tempDic.value(forKey: "message"){
                                        self.showAlertMessage(String(describing: errorMessage), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2.5))
                                        
                                    }
                                    return
                                }
                            }
                            //Successfull login
                            let defaults = UserDefaults.standard
                            defaults.set(tempDic.value(forKey: UserKeyConstants.jwtToekn), forKey: UserDefaultsConstant.jwtToekn)
                            defaults.set(tempDic.value(forKeyPath: UserKeyConstants.userInfoEmail), forKey: UserDefaultsConstant.userInfoEmail)
                            let x : UInt64 = tempDic.value(forKeyPath: UserKeyConstants.userInfoId) as! UInt64
                            let userIdString = String(x)
                            defaults.set(userIdString, forKey: UserDefaultsConstant.userInfoId)
                            defaults.set(tempDic.value(forKeyPath: UserKeyConstants.userInfoName), forKey: UserDefaultsConstant.userInfoName)
                            defaults.set(tempDic.value(forKeyPath: UserKeyConstants.userInfoStatus), forKey: UserDefaultsConstant.userInfoStatus)
                            defaults.synchronize()
                            
                            //                            Crashlytics.sharedInstance().setUserIdentifier(ADUtility.getUserId()!)
                            //                            Crashlytics.sharedInstance().setUserEmail(ADUtility.getUseremail()!)
                            
                            if let userId = ADUtility.getUserId(){
                                Crashlytics.sharedInstance().setUserIdentifier(userId)
                            }
                            if let email = ADUtility.getUseremail(){
                                Crashlytics.sharedInstance().setUserEmail(email)
                            }
                            
                            //Update device token on server
                            self.updateDeviceTokenOnServer()
                            //Login successful, move to next screen
                            self.openHomeViewController()
                        }
                    })
                    
                }, failure: { (error) in
                    DispatchQueue.main.async(execute: {
                        self.hideActivityIndicatorView()
                        self.showAlertMessage(NSLocalizedString("no_internet_connection", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                    })
                })
                
            }
            else{
                self.showAlertMessage(NSLocalizedString("no_internet_connection", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            }
        }
    }
    
    @IBAction func closeAction(_ sender: AnyObject){
        self.dismissKeyBoard()
        self.dismiss(animated: true) {
            
        }
    }
    
    func checkValidation() -> Bool {
        if (self.emailTextField.text?.isBlank)! {
            self.showAlertMessage(NSLocalizedString("please_enter_register_email_id", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if false == (self.emailTextField.text?.isEmailValid(enteredEmail: self.emailTextField.text!))!{
            self.showAlertMessage("Email is not valid", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if(self.passwordTextField.text?.isBlank)!{
            self.showAlertMessage("Password is required", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        return true
    }
    
    func dismissKeyBoard() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    //MARK : Textfield delegate
    //MARK : Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if (textField == passwordTextField){
            textField.resignFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    //MARK : Keyboard Notification
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if(iPhone4or4S || iPhone5or5S){
                self.registerBtn.isHidden = true
                self.loginBtn.isHidden = true
            }
            let height = keyboardSize.height
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.loginBtnBottomConstraint.constant = height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            self.loginBtnBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            if(iPhone4or4S || iPhone5or5S){
                self.registerBtn.isHidden = false
                self.loginBtn.isHidden = false
            }
        })
    }
}
