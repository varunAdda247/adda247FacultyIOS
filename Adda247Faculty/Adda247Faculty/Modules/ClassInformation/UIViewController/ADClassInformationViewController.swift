//
//  ADClassInformationViewController.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 27/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import UIKit

enum ADClassInfoType: String{
    case tableViewTypeCompletedStatus = "CompletedClass"
    case tableViewTypeToStartClassStatus = "StartClass"
    case tableViewTypeToEndClassStatus = "EndClass"
    case tableViewTypeAnotherClassIsActiveStatus = "AnotherClassActive"
    case tableViewTypeMissedClassStatus = "MissedClass"
    case tableViewTypeTimeRemainingClassToStartStatus = "TimeRemainingInClass"
    
}

enum ADTableViewCellType: String{
    case classInfoHeadingAndSubHeadingCell = "ADClassInfoHeadingAndSubHeadingCell"
    case classInfoHeadingSubHeadingAndImageCell = "ADClassInfoHeadingSubHeadingAndImageCell"
    case classInfoHeadingSubHeadingImageAndButtonCell = "ADClassInfoHeadingSubHeadingImageAndButtonCell"
    case classInfoWithTwoIconsCell = "ADClassInfoWithTwoIconsCell"
}


class ADClassInformationViewController: UIViewController {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    
    let cornerRadius:CGFloat = 10.0
    var teacherClass: TeacherClass?
    var heading: String?
    var completion: ((String)-> Void)?
    var infoType: ADClassInfoType!
    
    var cellTypeArray:[ADTableViewCellType] = []
    
    static func getClassInfoVC(with heading:String, teacherClass:TeacherClass,infoType:ADClassInfoType,closure:((String)-> Void)?) -> ADClassInformationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:ADClassInformationViewController = storyboard.instantiateViewController(withIdentifier: "ADClassInformationViewController") as! ADClassInformationViewController
        controller.teacherClass = teacherClass
        controller.completion = closure
        controller.infoType = infoType
        
        if(infoType == ADClassInfoType.tableViewTypeCompletedStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
//            controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeToStartClassStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
           // controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeToEndClassStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
           // controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeAnotherClassIsActiveStatus){
           //controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeMissedClassStatus){
            //controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeTimeRemainingClassToStartStatus){
//            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
        }
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializeView() {
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        headingLabel.text = heading
        crossButton.setImage(UIImage(named: "cross")?.withRenderingMode(.alwaysTemplate), for: .normal)
        crossButton.tintColor = UIColor(red: 3.0/255, green: 3.0/255, blue: 3.0/255, alpha: 1.0)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        self.tableViewHeightConstraint.constant = CGFloat((self.cellTypeArray.count*65 + 50 + 50))
        self.view.layoutIfNeeded()
        
        self.headingLabel.text = self.teacherClass?.classNam
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        
        self.removeChildViewController(content: self, animate: true)
            
    }
    
    func sendClosure() {
        if (completion != nil) {
            completion!("")
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate Methods
extension ADClassInformationViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.cellTypeArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = self.cellTypeArray[indexPath.row].rawValue
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ADClassStatusTableViewCellProtocol
        
        if(infoType == ADClassInfoType.tableViewTypeCompletedStatus){
           self.populateCellForCompltedStatus(cell: cell, indexPath: indexPath)
        }
        
        return cell as! UITableViewCell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 65.0
    }
    
    func populateCellForCompltedStatus(cell:ADClassStatusTableViewCellProtocol,indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let cell = cell as! ADClassInfoHeadingSubHeadingAndImageCell
            let actualStartTime = ADUtility.timeFromTimeStamp(timeStamp: (self.teacherClass?.actualStartTs)!)
            cell.populate(actualStartTime, subTitle: "Scheduled on", iconImage: "")
            break
        case 1:
            let cell = cell as! ADClassInfoHeadingSubHeadingAndImageCell
            cell.populate((self.teacherClass?.centerName)!, subTitle: "Center", iconImage: "")
            break
        case 2:
            let cell = cell as! ADClassInfoWithTwoIconsCell
            let startTimeTemp = ADUtility.timeFromTimeStamp(timeStamp: (self.teacherClass?.startTime)!)
            let endTimeTemp = ADUtility.timeFromTimeStamp(timeStamp: (self.teacherClass?.endTime)!)

            cell.populate(startTime: startTimeTemp, endTime: endTimeTemp)
            break
        case 3:
            let cell = cell as! ADClassInfoHeadingSubHeadingAndImageCell
            cell.populate("Today", subTitle: "Scheduled on", iconImage: "")
            break
        default:
           break
        }
    }
}
