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

class ADHomeViewController: UIViewController,UIActionSheetDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var classScheduleTableView: UITableView!

    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController =
    { () -> NSFetchedResultsController<NSFetchRequestResult> in
        // Initialize Fetch Request
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeacherClass")
        
        var predicate:NSPredicate?
        let defaults = UserDefaults.standard
        predicate = NSPredicate(format: "exams.examId == %@  AND category == %@","DAILY","")

        fetchRequest.returnsDistinctResults = true
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "actualStartTs", ascending: false)
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
            self.classServiceCall()
        }
        
        self.classScheduleTableView.estimatedRowHeight = 115.0
        self.classScheduleTableView.rowHeight = UITableViewAutomaticDimension

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.classScheduleTableView.reloadData()
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
        self.profileNameLbl.text = "Hi \(ADUtility.getFacultyName()!)"
    }
    
    
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
        
        TeacherClass.fetchClassData(parameters: tempPara) { (successfullySaved, error) in
            if successfullySaved{
                if ((self.fetchedResultsController.fetchedObjects?.count)! > 0){
                    self.classScheduleTableView.isHidden = false
                    self.classScheduleTableView.reloadData()
                }
                else{
                    //No class data
                    print("No class data found")
                }
                
            }
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
                cell.statusLbl.text = "Completed"
                cell.flagView.backgroundColor = UIColor.green
                cell.classNameLbl.text = cfObj.classNam!

//                if(indexPath.row == 0){
//                    cell.classNameLbl.text = "To te djd fhjkdf  hsdhksd hjkdh fhhdfksf kjhfsd hjkhdsf jkh"
//                }
//                else{
//                    cell.classNameLbl.text = cfObj.classNam!
//                }
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Action according to status here
        
    }
}
