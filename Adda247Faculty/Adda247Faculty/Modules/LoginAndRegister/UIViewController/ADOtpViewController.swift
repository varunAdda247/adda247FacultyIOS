//
//  ADOtpViewController.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 20/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADOtpViewController: UIViewController{
    //MARK: Outlets
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var numberOfCharectorsLbl: UILabel!
    @IBOutlet weak var forgotPasswordLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var resendBtnBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var tryAfterSomeTimeLbl: UILabel!
    var timer: Timer?
    var count = 30

    let OTP_TEXT_LIMIT = 4
    var mobileNumber:String!
    var tap:UITapGestureRecognizer?
    
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
        self.resendBtn.isHidden = true
        self.configureInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.otpTextField.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Internal methods
    func configureInitialValues() {
        self.view.backgroundColor = UIColor.backgroundThemeColor()
        self.messageLbl.text = "Please enter the OTP sent to \(self.mobileNumber!)"
        self.otpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //Disable Resend button for 30 seconds
        self.resendBtn.isEnabled = false
        self.startTimer()
        
    }
    
    func startTimer()  {
        self.removeTapGesture()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTime), userInfo: nil, repeats: true)
        self.tryAfterSomeTimeLbl.text = "Retry after \(count) seconds"
    }
    
    func stopTimer()  {
        self.timer?.invalidate()
    }
    
    func addTapGesture()  {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(ADOtpViewController.tapFunction))
        self.tryAfterSomeTimeLbl.isUserInteractionEnabled = true
        self.tryAfterSomeTimeLbl.addGestureRecognizer(tap!)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        self.resendOTPAction()
    }
    
    func removeTapGesture()  {
        if let tap = self.tap{
            self.tryAfterSomeTimeLbl.removeGestureRecognizer(tap)
        }
    }
    
    @objc func getTime() {
        count = count - 1
        if(count >= 0){
            self.tryAfterSomeTimeLbl.text = "Retry after \(count) seconds"
        }
        else{
            self.addTapGesture()
            self.tryAfterSomeTimeLbl.text = "RESEND OTP"
            self.stopTimer()
            self.count = 30
        }
    }
    
    @IBAction func resendOTPAction() {
        
        if Reachability.connectionAvailable() {
           
            self.showActivityIndicatorInteractionEnabledView(true)
            
            let suffixUrl = "\(APIURLSuffix.resendOtp)?mobile=\(self.mobileNumber!)"
            
            //Service Call to Resend OTP to email
            _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: nil, success: { (response) in
                DispatchQueue.main.async(execute: {
                    self.hideActivityIndicatorView()
                    self.showAlertMessage("OTP sent successfully", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 1))
                    self.startTimer()
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
    
    func openSetNewPinController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:ADSetNewPinViewController = storyboard.instantiateViewController(withIdentifier: "ADSetNewPinViewController") as! ADSetNewPinViewController
        controller.mobileNumber = self.mobileNumber
        self.present(controller, animated: true) {
           
        }
    }
    
    func verifyOTP(){
        
        if Reachability.connectionAvailable() {
            
            //&otp=1236
            self.showActivityIndicatorInteractionEnabledView(true)
            //Service Call to Resend OTP to email
            
            let suffixUrl = "\(APIURLSuffix.phoneNumberVerification)?mobile=\(self.mobileNumber!)&otp=\(self.otpTextField.text!)"

            _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: nil, success: { (response) in
                
                if let unwrapped = response as? Dictionary<String, Any> {
                    
                    if let success = unwrapped["success"] as? NSNumber{
                        if(success == 1){
                            if let data = unwrapped["data"] as? Dictionary<String, Any>{
                                if let statusCode = data["statusCode"] as? NSNumber{
                                    if(statusCode == 0){
                                        //OTP Verified successfully.
                                        //Save token
                                        if let token  = data["token"] as? String{
                                            ADUtility.updateToken(token: token)
                                        }
                                        
                                        //Now move to set PIN
                                        DispatchQueue.main.async(execute: {
                                            self.hideActivityIndicatorView()
                                            self.openSetNewPinController()
                                        })
                                    }
                                    else if(statusCode == 1){
                                        //OTP mismatch
                                    }
                                    
                                    //To display message
                                    if let message = unwrapped["message"] as? String{
                                        DispatchQueue.main.async(execute: {
                                            self.hideActivityIndicatorView()
                                            self.showAlertMessage(message, alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                                        })
                                        
                                    }

                                }
                            }
                        }
                    }
                }
                
                
            }, failure: { (error) in
                DispatchQueue.main.async(execute: {
                    self.hideActivityIndicatorView()
                    self.showAlertMessage("OTP verification failed, please retry", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                })
            })
            
        }
        else{
            self.showAlertMessage(NSLocalizedString("no_internet_connection", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
        }
        
    }
    
    //MARK : Keyboard Notification
//    @objc func keyboardWillShow(notification: NSNotification) {
//
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            let height = keyboardSize.height
//            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.resendBtnBottomConstraint.constant = height
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//
//        UIView.animate(withDuration: 0.1, animations: { () -> Void in
//
//            self.resendBtnBottomConstraint.constant = 0
//            self.view.layoutIfNeeded()
//
//        })
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.numberOfCharectorsLbl.text = "\((textField.text?.utf16.count ?? 0))/\(OTP_TEXT_LIMIT)"
        let textCount = (textField.text?.utf16.count ?? 0)
        if(textCount == OTP_TEXT_LIMIT){
            self.verifyOTP()
        }
    }
    
    
    //MARK: IBActions
    @IBAction func closeAction(){
        self.dismiss(animated: true) {
            
        }
    }
}

extension ADOtpViewController : UITextFieldDelegate{
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= OTP_TEXT_LIMIT
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
