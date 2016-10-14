//
//  MyGoalController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/12/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper
import Nuke


class MyGoalController: UIViewController{
    //MARK: Data
    
    var userGoalId: Int!
    var userGoal: UserGoal? = nil
    var customActions = [CustomAction]()
    var editingActions = [Bool]()
    
    
    //MARK: UI components
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hero: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var customContentContainer: UIView!
    @IBOutlet weak var customContentIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: ContentWrapUITableView!
    
    var tableViewConstraints = [NSLayoutConstraint]()
    
    var newActionCell: UserGoalNewCustomActionCell? = nil
    
    var selectedField: UITextField? = nil
    var scrolledBy: CGFloat = 0
    
    
    //MARK: Initial load methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //We need to know when the keyboard appears or goes away to adjust the scrollview's bottom
        //  constraint and scroll the view in order to have the text field being written to inside
        //  the screen
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MyGoalController.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MyGoalController.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
        
        //At load time the table should have nothing, as CustomActions need to be fetched, so
        //  remove it from the view hierarchy
        for constraint in customContentContainer.constraints{
            if constraint.belongsTo(tableView){
                tableViewConstraints.append(constraint)
            }
        }
        tableView.removeFromSuperview()
        //Set both the delegate and the data source
        tableView.dataSource = self
        tableView.delegate = self
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //If the UserGoal is nil fetch it, otherwise display it and fetch the custom actions
        if userGoal == nil{
            fetchGoal()
        }
        else{
            populateUI()
            fetchCustomActions()
        }
    }
    
    deinit{
        //Remove keyboard observers in the destructor
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func fetchGoal(){
        //Switch component state
        loadingIndicator.hidden = false
        errorMessage.hidden = true
        scrollView.hidden = true
        
        //Fire the request
        let headerMap = SharedData.user.getHeaderMap()
        Just.get(API.URL.getUserGoal(userGoalId), headers: headerMap){ (response) in
            if response.ok{
                self.userGoal = Mapper<UserGoal>().map(response.contentStr)
                dispatch_async(dispatch_get_main_queue(), {
                    self.populateUI()
                })
                self.fetchCustomActions()
            }
            else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingIndicator.hidden = true
                    self.errorMessage.hidden = false
                })
            }
        }
    }
    
    private func populateUI(){
        loadingIndicator.hidden = true
        errorMessage.hidden = true
        scrollView.hidden = false
        
        if let category = SharedData.getCategory(userGoal!.getPrimaryCategoryId()){
            setCategory(category)
        }
        goalTitle.text = userGoal!.getTitle()
        goalDescription.text = userGoal!.getDescription()
        customContentIndicator.hidden = false
    }
    
    private func setCategory(category: CategoryContent){
        if category.getImageUrl().characters.count != 0{
            Nuke.taskWith(NSURL(string: category.getImageUrl())!){
                self.hero.image = $0.image
            }.resume()
        }
    }
    
    private func fetchCustomActions(){
        let headerMap = SharedData.user.getHeaderMap()
        Just.get(API.URL.getCustomActions(userGoal!), headers: headerMap){ (response) in
            if response.ok{
                self.customActions = Mapper<CustomActionList>().map(response.contentStr)!.results
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.setCustomActions()
            })
        }
    }
    
    private func setCustomActions(){
        //Generate the editing flag list (false by default)
        for _ in customActions{
            editingActions.append(false)
        }
        //Add the table back to the layout
        customContentContainer.addSubview(tableView)
        for constraint in tableViewConstraints{
            customContentContainer.addConstraint(constraint)
        }
        customContentIndicator.hidden = true
        tableView.hidden = false
        tableView.invalidateIntrinsicContentSize()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func keyboardWillShow(notification: NSNotification){
        let info = notification.userInfo as! [String: AnyObject]
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        scrollViewBottomConstraint.constant = keyboardSize.height
        
        //If there ain't a selected field set, that means that the selected field is the
        //  new action field, for now scroll all the times
        if selectedField == nil{
            let newY = scrollView.contentOffset.y+keyboardSize.height
            scrollView.setContentOffset(CGPointMake(0, newY), animated: true)
        }
        else{
            let abs = selectedField!.superview!.convertPoint(selectedField!.frame.origin, toView: nil)
            let windowHeight = UIScreen.mainScreen().bounds.height
            
            let fPos = windowHeight - keyboardSize.height - 30
            let blCornerYPos = abs.y + selectedField!.frame.height
            if blCornerYPos > fPos{
                scrolledBy = blCornerYPos - fPos
                print(scrollView.contentOffset)
                let newY = scrollView.contentOffset.y+scrolledBy
                print(newY)
                scrollView.setContentOffset(CGPointMake(0, newY), animated: true)
            }
        }
        
        view.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification){
        scrollViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
        scrolledBy = 0
        selectedField = nil
    }
}


extension MyGoalController: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return customActions.count
        }
        if section == 1{
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(
                "UserGoalCustomActionCell",
                forIndexPath: indexPath
            )
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            let actionCell = cell as! UserGoalCustomActionCell
            actionCell.setAction(self, title: customActions[indexPath.row].getTitle())
            return actionCell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier(
                "UserGoalNewCustomActionCell",
                forIndexPath: indexPath
            )
            newActionCell = cell as? UserGoalNewCustomActionCell
            newActionCell?.delegate = self
            return newActionCell!
        }
    }
}


extension MyGoalController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0{
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! UserGoalCustomActionCell
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            let sheet = UIAlertController(
                title: "Choose an option", message: "",
                preferredStyle: UIAlertControllerStyle.ActionSheet
            )
            sheet.addAction(UIAlertAction(title: "Edit", style: .Default){ action in
                self.selectedField = cell.customAction
                cell.edit()
            })
            sheet.addAction(UIAlertAction(title: "Delete", style: .Destructive){ action in })
            sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            presentViewController(sheet, animated: true, completion: nil);
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 46
        }
        if indexPath.section == 1{
            return 85
        }
        return 0
    }
}


extension MyGoalController: UserGoalCustomActionCellDelegate, UserGoalNewCustomActionCellDelegate{
    func onAddCustomAction(title: String){
        Just.post(
            API.URL.postCustomAction(),
            headers: SharedData.user.getHeaderMap(),
            json: API.BODY.postPutCustomAction(title, goal: userGoal!)
        ){ (response) in
            if response.ok{
                self.customActions.append(Mapper<CustomAction>().map(response.contentStr)!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    CATransaction.begin()
                    CATransaction.setCompletionBlock(){
                        self.tableView.invalidateIntrinsicContentSize()
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                    }
                    self.tableView.reloadData()
                    self.tableView.sizeToFit()
                    CATransaction.commit()
                })
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.newActionCell?.onActionSaveComplete(response.ok)
            })
        }
    }
    
    func onSaveCustomAction(newTitle: String){
        
    }
}


extension MyGoalController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
