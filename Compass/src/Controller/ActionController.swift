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
import Crashlytics


class ActionController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    //Data
    var delegate: ActionDelegate? = nil
    var action: Action? = nil
    var message: APNsMessage? = nil
    var startTime: Double = 0
    var enterBackgroundTime: Double = -1
    
    
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
    @IBOutlet weak var goalContainer: UIView!
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
    //  More info
    @IBOutlet weak var moreInfoRuler: UIView!
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
        
        let goal = UITapGestureRecognizer(target: self, action: #selector(ActionController.handleTap(_:)));
        goal.delegate = self;
        goalContainer.addGestureRecognizer(goal);
        
        if action != nil{
            laterButton.removeFromSuperview()
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
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(ActionController.appWillResignActive),
            name: UIApplicationWillResignActiveNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(ActionController.appWillTerminate),
            name: UIApplicationWillTerminateNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(ActionController.appWillEnterForeground),
            name: UIApplicationWillEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews(){
        goalIconContainer.layer.cornerRadius = goalIconContainer.frame.width/2
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        startTime = NSDate().timeIntervalSince1970
    }
    
    override func viewWillDisappear(animated: Bool){
        print("viewWillDisappear")
        recordTime()
        removeObservers()
        super.viewWillDisappear(animated)
    }
    
    func appWillResignActive(){
        enterBackgroundTime = NSDate().timeIntervalSince1970
    }
    
    func appWillTerminate(){
        if (enterBackgroundTime < 0){
            let now = NSDate().timeIntervalSince1970
            startTime += now-enterBackgroundTime
        }
        recordTime()
        removeObservers()
    }
    
    func appWillEnterForeground(){
        let now = NSDate().timeIntervalSince1970
        startTime += now-enterBackgroundTime
        enterBackgroundTime = -1
    }
    
    private func recordTime(){
        if action != nil{
            print("recording time")
            let now = NSDate().timeIntervalSince1970
            let time = Int(now-startTime)
            print(time)
            Answers.logContentViewWithName(
                action!.getTitle(),
                contentType: "Action",
                contentId: "\(action!.getId())",
                customAttributes: ["Duration": time]
            )
        }
    }
    
    private func removeObservers(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(
            self,
            name: UIApplicationWillResignActiveNotification,
            object: nil
        )
        notificationCenter.removeObserver(
            self,
            name: UIApplicationWillTerminateNotification,
            object: nil
        )
        notificationCenter.removeObserver(
            self,
            name: UIApplicationWillEnterForegroundNotification,
            object: nil
        )
    }
    
    func handleTap(sender: UITapGestureRecognizer?){
        if sender?.view == errorMessage{
            if message != nil{
                fetchAction()
            }
        }
        if sender?.view == goalContainer{
            if action is UserAction{
                performSegueWithIdentifier("ShowMyGoalFromAction", sender: nil)
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
        view.sendSubviewToBack(errorMessage)
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
            
            self.moreInfoRuler.removeFromSuperview()
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
        view.bringSubviewToFront(errorMessage)
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
        Just.post(API.getPostActionReportUrl(action!.getId()),
                  json: API.getPostActionReportBody("completed"),
                  headers: SharedData.user.getHeaderMap()){ (response) in }
        
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
        
        Just.put(API.getPutSnoozeUrl(message!.getNotificationId()),
                 json: API.getPutSnoozeBody(date, time: time),
                 headers: SharedData.user.getHeaderMap()){ (response) in }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "ShowMyGoalFromAction"{
            let myGoalController = segue.destinationViewController as! MyGoalController
            myGoalController.delegate = self
            myGoalController.userGoalId = (action as! UserAction).getPrimaryUserGoalId()
        }
    }
}


extension ActionController: MyGoalControllerDelegate{
    func onGoalRemoved(){
        if delegate != nil{
            delegate!.onGoalRemoved()
        }
        navigationController!.popViewControllerAnimated(true)
    }
}


extension ActionController: CoachMarksControllerDataSource, CoachMarksControllerDelegate{
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
    func onDidIt()
    func onGoalRemoved()
}
