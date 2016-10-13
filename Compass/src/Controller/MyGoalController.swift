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
    
    
    //MARK: UI components
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hero: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var customContentContainer: UIView!
    @IBOutlet weak var customContentIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: ContentWrapUITableView!
    
    var tableViewConstraints = [NSLayoutConstraint]()
    
    
    //MARK: Initial load methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        for constraint in customContentContainer.constraints{
            if constraint.belongsTo(tableView){
                tableViewConstraints.append(constraint)
            }
        }
        tableView.removeFromSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if userGoal == nil{
            fetchGoal()
        }
        else{
            populateUI()
            fetchCustomActions()
        }
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
        customContentContainer.addSubview(tableView)
        for constraint in tableViewConstraints{
            customContentContainer.addConstraint(constraint)
        }
        customContentIndicator.hidden = true
        tableView.hidden = false
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
            let cell = tableView.dequeueReusableCellWithIdentifier("UserGoalCustomActionCell")!
            let actionCell = cell as! UserGoalCustomActionCell
            return actionCell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("UserGoalNewCustomActionCell")!
            let newActionCell = cell as! UserGoalNewCustomActionCell
            return newActionCell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 46
        }
        if indexPath.section == 1{
            return 48
        }
        return 0
    }
}


extension MyGoalController: UITableViewDelegate{
    
}
