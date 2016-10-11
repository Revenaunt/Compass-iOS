//
//  ActionViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 5/31/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper
import Nuke
import Instructions


class ActionController: UIViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    //Data
    var delegate: ActionDelegate? = nil
    var action: Action? = nil
    var message: APNsMessage? = nil
    
    
    //UI components
    //  Activity indicator, error, and scroll view; only one of them is shown at the same time
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    //  Container for all views below
    @IBOutlet weak var masterContainer: UIView!
    //  Header
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var hero: UIImageView!
    //  Goal
    @IBOutlet weak var goalIconContainer: UIView!
    @IBOutlet weak var userGoalIcon: UIImageView!
    @IBOutlet weak var customGoalIcon: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    //  Action
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var actionDescription: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    //  Behavior
    @IBOutlet weak var moreInfoHeader: UILabel!
    @IBOutlet weak var moreInfo: UILabel!
    
    private let coachMarksController = CoachMarksController()
    

    override func viewDidLoad(){
        if (TourManager.getActionMarkerCount() != 0){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        }
        
        scrollView.delegate = self;
        
        //Set up the retry tap
        let retry = UITapGestureRecognizer(target: self, action: #selector(ActionController.handleTap(_:)));
        retry.delegate = self;
        errorMessage.addGestureRecognizer(retry);
        
        if action != nil{
            populateUI()
            if action is UserAction{
                let categoryId = (action as! UserAction).getPrimaryCategoryId()
                let category = SharedData.getCategory(categoryId)
                if category != nil{
                    setCategory(category!)
                }
                else{
                    fetchCategory(categoryId)
                }
            }
        }
        else if message != nil{
            fetchAction()
        }
        else{
            displayLoadingError()
        }
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlay.color = UIColor.clearColor();
    }
    
    override func viewDidLayoutSubviews(){
        goalIconContainer.layer.cornerRadius = goalIconContainer.frame.width/2
    }
    
    func handleTap(sender: UITapGestureRecognizer?){
        if sender?.view == errorMessage{
            if message != nil{
                fetchAction()
            }
        }
    }
    
    private func fetchAction(){
        loading.hidden = false
        errorMessage.hidden = true
        scrollView.hidden = true
        if message!.isUserActionMessage(){
            let url = API.getActionUrl(message!.getMappingId())
            Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
                if response.ok{
                    self.action = Mapper<UserAction>().map(response.contentStr)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.populateUI()
                    })
                    self.fetchCategory((self.action as! UserAction).getPrimaryCategoryId())
                }
                else{
                    self.displayLoadingError()
                }
            }
        }
        else if message!.isCustomActionMessage(){
            let url = API.URL.getCustomAction(message!.getObjectId())
            Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
                if response.ok{
                    self.action = Mapper<CustomAction>().map(response.contentStr)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.populateUI()
                    })
                }
                else{
                    self.displayLoadingError()
                }
            }
        }
    }
    
    private func populateUI(){
        if action is UserAction{
            let userAction = action as! UserAction
            Nuke.taskWith(NSURL(string: userAction.getGoalIconUrl())!){
                self.userGoalIcon.image = $0.image
            }.resume()
            actionDescription.text = userAction.getDescription()
            moreInfo.text = userAction.getMoreInfo()
        }
        else if action is CustomAction{
            if SharedData.user.isMale(){
                customGoalIcon.image = UIImage(named: "Guy")
            }
            else{
                customGoalIcon.image = UIImage(named: "Guy")
            }
            actionDescription.text = "This is an activity that you created when you set this goal for yourself. Congratulations for being so engaged! How's it going for you?"
            
            self.moreInfoHeader.removeFromSuperview()
            self.moreInfo.removeFromSuperview()
            self.masterContainer.setNeedsLayout()
            self.masterContainer.layoutIfNeeded()
            self.scrollView.contentSize = self.masterContainer.frame.size
        }
        
        goalTitle.text = action?.getGoalTitle()
        actionTitle.text = action?.getTitle()
        
        //Finally, display the content and hide the activity indicator
        loading.hidden = true
        scrollView.hidden = false
        
        //TODO: Fix this cluster
            if TourManager.getActionMarkerCount() != 0{
            let container = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y,
                self.scrollView.frame.size.width, self.scrollView.frame.size.height)
            if CGRectIntersectsRect(self.buttonContainer.frame, container){
                self.coachMarksController.startOn(self)
            }
            else{
                self.scrollView.scrollRectToVisible(self.buttonContainer.frame, animated: true)
            }
        }
    }
    
    private func displayLoadingError(){
        loading.hidden = true
        errorMessage.hidden = false
        scrollView.hidden = true
    }
    
    private func fetchCategory(id: Int){
        Just.get(API.URL.getCategory(id), headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.setCategory(Mapper<CategoryContent>().map(response.contentStr)!)
            }
        }
    }
    
    private func setCategory(category: CategoryContent){
        if (category.getImageUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: category.getImageUrl())!){
                self.hero.image = $0.image
            }.resume()
        }
        imageContainer.backgroundColor = category.getParsedColor()
        goalIconContainer.backgroundColor = category.getParsedColor()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView){
        coachMarksController.startOn(self);
    }
    
    @IBAction func later(){
        let alert = UIAlertController(title: "Later", message: "", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "In an hour", style: UIAlertActionStyle.Default, handler: { action in
            let date = NSDate(timeIntervalSinceNow: 3600);
            let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate: date);
            
            self.snooze(components.year, month: components.month, day: components.day,
                hour: components.hour, minute: components.minute);
            
            self.navigationController!.popViewControllerAnimated(true);
        }));
        alert.addAction(UIAlertAction(title: "This time tomorrow", style: UIAlertActionStyle.Default, handler: { action in
            let date = NSDate(timeIntervalSinceNow: 24*3600);
            let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate: date);
            
            self.snooze(components.year, month: components.month, day: components.day,
                hour: components.hour, minute: components.minute);
            
            self.navigationController!.popViewControllerAnimated(true);
        }));
        alert.addAction(UIAlertAction(title: "Someday", style: UIAlertActionStyle.Default, handler: { action in
            self.navigationController!.popViewControllerAnimated(true);
        }));
        presentViewController(alert, animated: true, completion: nil);
    }
    
    @IBAction func gotIt(){
        //Just.post(API.getPostActionReportUrl(mappingId), json: API.getPostActionReportBody("completed"),
        //          headers: SharedData.user.getHeaderMap()){ response in
                    
        //};
        if (delegate != nil){
            delegate!.onDidIt();
        }
        if (navigationController != nil){
            navigationController!.popViewControllerAnimated(true);
        }
    }
    
    func snooze(year: Int, month: Int, day: Int, hour:Int, minute: Int){
        let monthString = month < 10 ? "0\(month)" : "\(month)";
        let dayString = day < 10 ? "0\(day)" : "\(day)";
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)";
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)";
        
        let date = "\(year)-\(monthString)-\(dayString)";
        let time = "\(hourString):\(minuteString)";
        
        print(date + " " + time);
        
        //Just.put(API.getPutSnoozeUrl(notificationId), json: API.getPutSnoozeBody(date, time: time),
        //         headers: SharedData.user.getHeaderMap());
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        return TourManager.getActionMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex coachMarksForIndex: Int) -> CoachMark{
        switch (TourManager.getFirstUnseenActionMarker()){
        case .GotIt:
            var mark = coachMarksController.helper.coachMarkForView(gotItButton);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlay.color = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        default:
            break;
        }
        return coachMarksController.helper.coachMarkForView();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        let coachViews = coachMarksController.helper.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        switch (TourManager.getFirstUnseenActionMarker()){
        case .GotIt:
            coachViews.bodyView.hintLabel.text = "Tap here to let us know you did this.";
            coachViews.bodyView.nextLabel.text = "OK";
            
        default:
            break;
        }
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            UIApplication.sharedApplication().endIgnoringInteractionEvents();
        });
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int){
        TourManager.markFirstUnseenActionMarker();
    }
}

protocol ActionDelegate{
    func onDidIt();
}
