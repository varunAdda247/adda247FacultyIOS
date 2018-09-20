//
//  ADLoginViewConntroller.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 12/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit


class ADLoginViewConntroller: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var loginBtnBottomConstraint: NSLayoutConstraint!
    
    var mobileNumber = ""

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
        self.loginBtn.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
    }
    
    //MARK: IBActions
    @IBAction func forgotPasswordAction(_ sender: AnyObject){
        
        self.dismissKeyBoard()
        
        if Reachability.connectionAvailable() {
            //Service Call for forgot password
            self.forgotPinAction()
            
        }
        else{
            self.showAlertMessage(NSLocalizedString("no_internet_connection", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            
        }
        
    }
    
    
    @IBAction func loginAction(_ sender: AnyObject){
        if (self.checkValidation()){
            //Make call to login
            self.loginServiceCall()
        }
    }
    
    @IBAction func closeAction(_ sender: AnyObject){
        self.dismissKeyBoard()
        self.dismiss(animated: true) {
            
        }
    }
    
    func forgotPinAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:ADSetNewPinViewController = storyboard.instantiateViewController(withIdentifier: "ADSetNewPinViewController") as! ADSetNewPinViewController
        self.present(controller, animated: true) {
            
        }
    }
    
    func loginServiceCall() {
        
        let params:NSMutableDictionary = NSMutableDictionary()
        params.setObject(mobileNumber, forKey: "mobile" as NSCopying)
        params.setObject(self.pinTextField.text!, forKey: "pin" as NSCopying)

        let suffixUrl = "\(APIURLSuffix.login)?mobile=\(mobileNumber)&pin=\(self.pinTextField.text!)"

        self.showActivityIndicatorInteractionEnabledView(false)
        _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: params, success: { (response) in
            print(response)
            if let response = response as? Dictionary<String,Any>{
                if let data = response["data"] as? Dictionary<String,Any>{
                    
                    if let name = data["facultyName"] as? String{
                        //Update faculty name
                        ADUtility.updateFacultyName(name: name)
                    }
                    
                    if let token = data["token"] as? String{
                        //Update token
                        ADUtility.updateToken(token: token)
                    }
                    
                    if let id = data["facultyId"] as? String{
                        //Update token
                        ADUtility.updateFacultyId(id: id)
                    }
                    else if let id = data["facultyId"] as? NSNumber{
                        ADUtility.updateFacultyId(id: id.stringValue)
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
    
    func checkValidation() -> Bool {
        if (self.pinTextField.text?.isBlank)! {
            self.showAlertMessage(NSLocalizedString("please_enter_register_email_id", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        else if false == (self.pinTextField.text?.isPhoneNumberValid())!{
            self.showAlertMessage("Pin is not valid", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
            return false
        }
        
        return true
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
                self.loginBtnBottomConstraint.constant = height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.loginBtnBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}
