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
    
    
    let OTP_TEXT_LIMIT = 4
    var mobileNumber:String!
    
    // self.showAlertMessage("Internet is not available", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 1))
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.otpTextField.text = ""
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
    }
    
    @IBAction func resendOTPAction() {
        
        if Reachability.connectionAvailable() {
           
            self.showActivityIndicatorInteractionEnabledView(true)
            
            let suffixUrl = "\(APIURLSuffix.resendOtp)?mobile=\(self.mobileNumber)"
            
            //Service Call to Resend OTP to email
            _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: nil, success: { (response) in
                DispatchQueue.main.async(execute: {
                    self.hideActivityIndicatorView()
                    self.showAlertMessage("OTP sent successfully", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 1))
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
    
    func verifyOTP(){
        
        if Reachability.connectionAvailable() {
            
            //&otp=1236
            self.showActivityIndicatorInteractionEnabledView(true)
            //Service Call to Resend OTP to email
            
            let suffixUrl = "\(APIURLSuffix.phoneNumberVerification)?mobile=\(self.mobileNumber!)&otp=\(self.otpTextField.text!)"

            _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: suffixUrl, parameters: nil, success: { (response) in
                
                if let unwrapped = response as? Dictionary<String, Any> {
                    /*
                     {
                     data =     {
                     facultyId = "<null>";
                     facultyName = "<null>";
                     statusCode = 1;
                     token = "<null>";
                     };
                     message = "OTP mismatch.";
                     success = 1;
                     }
                     */
                    if let success = unwrapped["success"] as? NSNumber{
                        if(success == 0){
                            //successfull
                        }
                        else{
                            //not successfull
                            if let message = unwrapped["message"] as? String{
                                DispatchQueue.main.async(execute: {
                                    self.hideActivityIndicatorView()
                                    self.showAlertMessage(message, alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                                })
                                
                            }
                        }
                    }
                    //OTP verification is successfull
                    
                    
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
