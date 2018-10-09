//
//  ADHomeViewController.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 19/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation


class ADHomeViewController: UIViewController,UIActionSheetDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ADHomeViewController.fetchClassDetails(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    //MARK: Outlets
   // @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var classScheduleTableView: UITableView!

    
    @IBOutlet weak var emptyView: UIView!

    var locationManager: CLLocationManager?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController =
    { () -> NSFetchedResultsController<NSFetchRequestResult> in
        // Initialize Fetch Request
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeacherClass")
        
        var predicate:NSPredicate?
        let defaults = UserDefaults.standard
        let (startTimeStamp,endTimeStamp) = ADUtility.timeStampForTodayStartAndEndDate()

        predicate = NSPredicate(format: "startTime >= %ld AND startTime <= %ld",startTimeStamp,endTimeStamp)
        
       // predicate = NSPredicate(format: "startTime < %d",endTimeStamp)

        fetchRequest.predicate = predicate
        fetchRequest.returnsDistinctResults = true
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ADCoreDataHandler.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureInitialValues()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        if(self.fetchedResultsController.fetchedObjects?.count == 0){
            self.classScheduleTableView.isHidden = true
        }
        
        self.classServiceCall()

        self.classScheduleTableView.estimatedRowHeight = 115.0
        self.classScheduleTableView.rowHeight = UITableViewAutomaticDimension
        self.classScheduleTableView.addSubview(self.refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.classScheduleTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
        self.determineMyCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func rightBarButtonTap() {
        //TODO
        self.openActionSheetToLogout()
    }
    
    func backgroundServiceCallToSendPandingDataToServer() {
        DispatchQueue.global(qos: .background).async {
           var tempArray:[TeacherClass] = []
           if((self.fetchedResultsController.fetchedObjects?.count)! > 0){
            for object in self.fetchedResultsController.fetchedObjects!{
                let tempObj = object as! TeacherClass
                if(!tempObj.isUpdatedOnServer){
                    //Need to update this data to server
                    tempArray.append(tempObj)
                }
            }
            ADServiceCallManager.sendPandingDataToServer(array: tempArray)
           }
        }
    }
    
    func addEmptyView() {
        emptyView?.isHidden = false
    }
    
    func removeEmptyView() {
        if(emptyView !=  nil){
            emptyView?.isHidden = true
        }
    }
    
    func determineMyCurrentLocation() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            //self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        manager.stopUpdatingLocation()
     
    }
    
    func openActionSheetToLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default , handler:{ (UIAlertAction)in
            //LOGOUT
            print("Logout action")
            self.logoutAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
            //Cancel
            print("Cancel action")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func logoutAction() {
        ADUtility.updateToken(token: "")
        ADUtility.updateFacultyId(id: "")

        let controller:ADEnterMobileNumberViewController = UIStoryboard.instantiateController(forModule: ADStoryModule.main)
        let navigationController = UINavigationController(rootViewController: controller)
        
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction( name:kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        CATransaction.begin()
        AppDelegate.getDelegate().window?.layer.add(transition, forKey: nil)
        
        AppDelegate.getDelegate().window?.rootViewController = navigationController
        AppDelegate.getDelegate().window?.makeKeyAndVisible()
        CATransaction.commit()
    }
    
    //MARK: Internal methods
    func configureInitialValues() {
        self.addRightButtonWithImage(imageName: "overflow", target: self)
        if let facultyName = ADUtility.getFacultyName(){
            self.profileNameLbl.text = "Hi \(facultyName)"
        }
        
       // let profileImage = nil
       // self.profileImgView.maskCircle(anyImage: UIImage(named: "profilePlaceHolder")!)
                
        self.classScheduleTableView?.layer.cornerRadius = 5
        self.classScheduleTableView?.layer.masksToBounds = true
        self.classScheduleTableView?.layer.borderColor = UIColor.clear.cgColor
        self.classScheduleTableView?.layer.borderWidth = 1
        self.classScheduleTableView?.clipsToBounds = true
    }
    
    
    @objc func fetchClassDetails(_ refreshControl: UIRefreshControl) {
        
        if Reachability.connectionAvailable(){
           self.classServiceCall()
        }
        else{
            self.refreshControl.endRefreshing()
            self.showAlertMessage(NSLocalizedString("no_internet_connection", comment: ""), alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
        }
    }
    
    func classServiceCall() {
        
        if Reachability.connectionAvailable(){
            let tempPara:NSMutableDictionary = NSMutableDictionary()
            tempPara.setObject([], forKey: "classDetailsList" as NSCopying)
            
            let (startTimeStamp,endTimeStamp) = ADUtility.timeStampForTodayStartAndEndDate()
            let timeInterval:NSMutableDictionary = NSMutableDictionary()
            timeInterval.setObject(startTimeStamp, forKey: "startTime" as NSCopying)
            timeInterval.setObject(endTimeStamp, forKey: "endTime" as NSCopying)
            tempPara.setObject(timeInterval, forKey: "timeInterval" as NSCopying)
            tempPara.setObject(false, forKey: "isTopicsRequired" as NSCopying)
            
            if let facultyId = ADUtility.getFacultyId(){
                tempPara.setObject(facultyId, forKey: "facultyId" as NSCopying)
            }
            
            TeacherClass.fetchClassData(parameters: tempPara) { (successfullySaved, error) in
                if successfullySaved{
                    if ((self.fetchedResultsController.fetchedObjects?.count)! > 0){
                        self.classScheduleTableView.isHidden = false
                        self.refreshControl.endRefreshing()
                        self.classScheduleTableView.reloadData()
                        //self.removeEmptyView()
                    }
                    else{
                        //No class data
                        //self.addEmptyView()
                        self.showAlertMessage("You don't have any classes scheduled for today", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
                    }
                    
                }
                else{
                    if(error?.code == 1005){
                        //Authentication error
                        self.showAlertViewControllerWithTitle("", message: "Your account was logged in from another device. Try logging in again.", actionButtonTitle: "Login", completionHandler: {[weak self] (action) in
                            self?.logoutAction()
                        })
                    }
                }
            }
        }
        else{
            self.showAlertMessage("No internet connection", alertImage: nil, alertType: .success, context: .statusBar, duration: .seconds(seconds: 2))
        }
        
    }
    
    
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.classScheduleTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.classScheduleTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.classScheduleTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            break;
        default:
            break;
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            //            if indexPath == nil{
            //                if let indexPath = newIndexPath {
            //                    self.currentAffairsTableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            //                }
            //            }
            if let indexPath = newIndexPath {
                self.classScheduleTableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                self.classScheduleTableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                
                if let cell = self.classScheduleTableView.cellForRow(at: indexPath as IndexPath) as? ADClassDataCell {
                    
                    self.configureClassDataCell(cell: cell, atIndexPath: indexPath)
                }
            }
            break;
        case .move:
            if let indexPath = indexPath {
                self.classScheduleTableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                self.classScheduleTableView.insertRows(at: [newIndexPath as IndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.classScheduleTableView.endUpdates()
    }
    
    func getClassStatus(classObj:TeacherClass,cell:ADClassDataCell) -> String {
        
        if(ADUtility.timeStampFor(date: Date()) > classObj.endTime){
            //Missed class
            cell.flagView.backgroundColor = UIColor.init(hexString: "#f44336")
            return "MISSED CLASS"
        }
        else{
            //Start classce
            print("Start class")
            cell.flagView.backgroundColor = UIColor.init(hexString: "#1976d2")
            let startTime = ADUtility.timeFromTimeStamp(timeStamp: (classObj.startTime))
            return "Today \(startTime)"
         }
     }
}

// MARK: - UITableViewDataSource, UITableViewDelegate Methods
extension ADHomeViewController : UITableViewDataSource, UITableViewDelegate
{
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fetchedResultsController.fetchedObjects?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.classScheduleTableView.dequeueReusableCell(withIdentifier: "ADClassDataCell") as! ADClassDataCell
        
        // Configure Table View Cell
        self.configureClassDataCell(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    
    func configureClassDataCell(cell: ADClassDataCell, atIndexPath indexPath: IndexPath) {
        if self.fetchedResultsController.validateIndexPath(indexPath) {
            if let cfObj = self.fetchedResultsController.object(at: indexPath) as? TeacherClass{
                //Upate object
                print("Start time : \(cfObj.startTime) :: Center : \(cfObj.centerName!)")
                cell.statusLbl.text = "Completed"
                if(cfObj.classStatus == 0){
                    cell.statusLbl.text = self.getClassStatus(classObj: cfObj, cell: cell)
                }
                else if(cfObj.classStatus == 1){
                    cell.statusLbl.text = "CLASS STARTED"
                    cell.flagView.backgroundColor = UIColor.init(hexString: "#ec407a")
                }
                else if(cfObj.classStatus == 2){
                    cell.statusLbl.text = "COMPLETED"
                    cell.flagView.backgroundColor = UIColor.init(hexString: "#00c853")
                }
                cell.classNameLbl.text = cfObj.classNam!
                
                cell.centerLbl.text = cfObj.centerName!
            }
        } else {
            self.classScheduleTableView.reloadData()
        }
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       // return UITableViewAutomaticDimension
        return 120.0
    }
    
    func isLocationEnabledByUser() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                return false
            case .restricted:
                return false
            case .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    
    func openAlertControllerToMoveToSettigns() {
        let alertController = UIAlertController (title: "You must on your location sharing to continue", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Action according to status here
        if let cfObj = self.fetchedResultsController.object(at: indexPath) as? TeacherClass{
            //Upate object
            print("\(cfObj.classStatus)")
        
            if(!self.isLocationEnabledByUser()){//If not enaled that stop user to move forword
                self.openAlertControllerToMoveToSettigns()
                return
            }
            
            let controller:ADClassInformationViewController
            if(cfObj.classStatus == 0){
                //Open upcoming details
                //Check if user missed the class or time remaining to start
                if(ADUtility.timeStampFor(date: Date()) > cfObj.endTime){
                    //Missed class
                    print("Missed class")
                    controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeMissedClassStatus) { (action) in
                    }

                }
                else if((cfObj.startTime - ADUtility.timeStampFor(date: Date())) > (5*60*1000)){
                    //Time remaining to start class : if want to start from 5 minutes earlier
                    print("Time remain to start class")
                    if(self.isAnotherClassIsActive()){
                        controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeAnotherClassIsActiveStatus) { (action) in
                        }
                    }
                    else{
                        controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeTimeRemainingClassToStartStatus) { (action) in
                        }
                    }
                }
                else{
                    //Start class
                    print("Start class")
                    if(self.isAnotherClassIsActive()){
                        controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeAnotherClassIsActiveStatus) { (action) in
                        }
                    }
                    else{
                        controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeToStartClassStatus) { (action) in
                        }
                    }
                   
                }
               
            }
            else if(cfObj.classStatus == 1){
                //Open On going details
                controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeToEndClassStatus) { (action) in
                }
            }
            else {// 2 for completed
               //Open completed details
                controller = ADClassInformationViewController.getClassInfoVC(with: "", teacherClass: cfObj, infoType: ADClassInfoType.tableViewTypeCompletedStatus) { (action) in
                    
                }
            }
            
            self.openChildViewController(content: controller, animate: true)
        }
    }

    
    func isAnotherClassIsActive() -> Bool {
        for object in self.fetchedResultsController.fetchedObjects!{
            let tempObj = object as? TeacherClass
            if(tempObj?.classStatus == 1){
                return true
            }
        }
        return false
    }
}
