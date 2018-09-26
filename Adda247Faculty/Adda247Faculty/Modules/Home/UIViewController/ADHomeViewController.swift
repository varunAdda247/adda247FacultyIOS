//
//  ADHomeViewController.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 19/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADHomeViewController: UIViewController,UIActionSheetDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var classScheduleTableView: UITableView!

    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.defaultSettings()
        self.navigationItem.title = "Home"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func rightBarButtonTap() {
        //TODO
        self.openActionSheetToLogout()
    }
    
    func openActionSheetToLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default , handler:{ (UIAlertAction)in
            //LOGOUT
            print("Logout action")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
            //Cancel
            print("Cancel action")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //MARK: Internal methods
    func configureInitialValues() {
        self.addRightButtonWithImage(imageName: "overflow", target: self)
        self.classServiceCall()
    }
    
    //MARK: IBActions
//    @IBAction func continueAction(_ sender: AnyObject){
//
//    }
    
    func classServiceCall() {
        
        let tempPara:NSMutableDictionary = NSMutableDictionary()
        tempPara.setObject([], forKey: "classDetailsList" as NSCopying)
        
        let (startTimeStamp,endTimeStamp) = ADUtility.timeStampForTodayStartAndEndDate()
        let timeInterval:NSMutableDictionary = NSMutableDictionary()
        timeInterval.setObject(startTimeStamp, forKey: "startTime" as NSCopying)
        timeInterval.setObject(endTimeStamp, forKey: "endTime" as NSCopying)
        tempPara.setObject(timeInterval, forKey: "timeInterval" as NSCopying)
        tempPara.setObject(false, forKey: "isTopicsRequired" as NSCopying)

        let facultyId = ADUtility.getFacultyId()!.int16Value
        tempPara.setObject(facultyId, forKey: "facultyId" as NSCopying)

        //facultyId
        //startTime
        //endTime
        
        _ = ADWebClient.sharedClient.POST(appbBaseUrl: APIURL.baseUrl, suffixUrl: APIURLSuffix.getClasses, parameters: tempPara, success: { (response) in
            if let response = response as? Dictionary<String,Any>{
                if let data = response["data"] as? Dictionary<String,Any>{
                    /*
                     {
                     actualEndTs = 1531809843146;
                     actualStartTs = 1531809833459;
                     centerName = "Agra - Bhagwan Talkies";
                     classId = 104; // PRIMARY KEY
                     className = "ABT087-006-Science";
                     classStatus = 2; //0: Not started(missed, upcoming, going to start), 1: Active, 2: Completed
                     endLocation = "28.4437044:77.055694"; // location
                     endTime = 1531819800000; // Actual time set by server
                     facultyName = "<null>"; //
                     lastUpdatedTs = 1531809843146; // to manage latest data in DB
                     startLocation = "28.4437044:77.055694";// location
                     startTime = 1531816200000;// Actual time set by server
                     topics = "<null>";topicId,status(0:fresh, 1: Started but not finish,2:Finished),topicName
                     },
                    */
                    
                    //Open home view conntroller
                    DispatchQueue.main.async(execute: {
                        
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
}
