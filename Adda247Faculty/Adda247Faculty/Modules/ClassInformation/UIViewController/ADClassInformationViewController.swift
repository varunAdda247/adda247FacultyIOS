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
    case tableViewTypeStartClassStatus = "StartClass"
    case tableViewTypeEndClassStatus = "EndClass"
    case tableViewTypeAnotherClassIsActiveStatus = "AnotherClassActive"
    case tableViewTypeMissedClassStatus = "MissedClass"
    case tableViewTypeTimeRemainingClassStatus = "TimeRemainingInClass"
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
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
//            controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeStartClassStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeEndClassStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoWithTwoIconsCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeAnotherClassIsActiveStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeMissedClassStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
        }
        else if(infoType == ADClassInfoType.tableViewTypeTimeRemainingClassStatus){
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingAndSubHeadingCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingImageAndButtonCell)
            controller.cellTypeArray.append(ADTableViewCellType.classInfoHeadingSubHeadingAndImageCell)
        }
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        headingLabel.text = heading
        crossButton.setImage(UIImage(named: "cross")?.withRenderingMode(.alwaysTemplate), for: .normal)
        crossButton.tintColor = UIColor(red: 3.0/255, green: 3.0/255, blue: 3.0/255, alpha: 1.0)
        
        if tableViewHeightConstraint.constant>(UIScreen.height-90) {
            tableViewHeightConstraint.constant = UIScreen.height-90
        }
        // Do any additional setup after loading the view.
        self.containerView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerViewTopConstraint.constant = -(self.containerView.bounds.height+30)
        
        self.showOptionsWithAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.showOptionsWithAnimation()
    }
    
    func showOptionsWithAnimation(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // change 2 to desired number of seconds
            //Your code with delay
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn], animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
                self.containerViewTopConstraint.constant = 10.0
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
            self.containerViewTopConstraint.constant = -(self.containerView.bounds.height+30)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        }) { (isCompleted) in
            self.dismiss(animated: true) {
                self.sendClosure()
            }
        }
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
        cell.populate("title", subTitle: "subtitle")
        cell.populate("title", subTitle: "subtitle", iconImage: "")
        
        return cell as! UITableViewCell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(self.infoType == ADClassInfoType.tableViewTypeEndClassStatus){
            return 65.0
        }
        return 48.0
    }
}
