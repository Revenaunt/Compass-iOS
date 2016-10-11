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


class ActionController: UIViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate, UIScrollViewDelegate{
    //Data
    var delegate: ActionDelegate? = nil
    var action: Action? = nil
    var notification: APNsMessage? = nil
    
    
    //UI components
    //  Activity indicator and scroll view, only one of them is shown at the same time
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    //  Header
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var hero: UIImageView!
    @IBOutlet weak var actionTitle: UILabel!
    //  Goal
    @IBOutlet weak var goalIconContainer: UIView!
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    //  Action
    @IBOutlet weak var actionDescription: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    //  Behavior
    @IBOutlet weak var behaviorDescription: UILabel!
    
    private let coachMarksController = CoachMarksController()
    

    override func viewDidLoad(){
        if (TourManager.getActionMarkerCount() != 0){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        }
        
        scrollView.delegate = self;
        
        //Remove all items from the master containes (except for the header) and the author
        actionTitle.removeFromSuperview();
        actionDescription.removeFromSuperview();
        buttonContainer.removeFromSuperview();
        
        //Either the mappingId is set or the upcomingAction is set (xor), select the propper mappingId
        /*if (upcomingAction != nil){
            laterButton.hidden = true;
            mappingId = upcomingAction!.getId();
        }*/
        
        //print("Mapping id: \(mappingId)")
        
        //Fetch the action
        /*Just.get(API.getActionUrl(mappingId), headers: SharedData.user.getHeaderMap()) { (response) in
            //print(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
            if (response.ok){
                //Parse and populate
                let action = Mapper<UserAction>().map(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.actionTitle.text = action!.getTitle();
                    self.behaviorTitle = action!.getBehaviorTitle();
                    self.behaviorDescription = action!.getBehaviorDescription();
                    self.actionDescription.text = action!.getDescription();
                    
                    self.masterContainer.addSubview(self.actionTitle);
                    self.masterContainer.addSubview(self.actionDescription);
                    self.masterContainer.addSubview(self.buttonContainer);
                    self.masterContainer.addConstraints(self.actionConstraints);
                    self.masterContainer.setNeedsLayout();
                    self.masterContainer.layoutIfNeeded();
                    self.scrollView.contentSize = self.masterContainer.frame.size;
                    
                    if (TourManager.getActionMarkerCount() != 0){
                        let container = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y,
                                                   self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                        if (CGRectIntersectsRect(self.buttonContainer.frame, container)){
                            self.coachMarksController.startOn(self);
                        }
                        else{
                            self.scrollView.scrollRectToVisible(self.buttonContainer.frame, animated: true);
                        }
                    }
                });
                //Fetch the hero
                let category = SharedData.getCategory(action!.getPrimaryCategoryId());
                if (category != nil && category!.getImageUrl().characters.count != 0){
                    Nuke.taskWith(NSURL(string: category!.getImageUrl())!){
                        self.hero.image = $0.image;
                    }.resume();
                }
            }
        };*/
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlay.color = UIColor.clearColor();
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView){
        coachMarksController.startOn(self);
    }
    
    private func belongsTo(constraint: NSLayoutConstraint, view: UIView) -> Bool{
        return constraint.firstItem === view || constraint.secondItem === view;
    }
    
    private func fetchCategory(categoryId: Int){
        Just.get(API.getUserCategoryUrl(categoryId), headers: SharedData.user.getHeaderMap()) { (response) in
            if (response.ok){
                let category = Mapper<ParserModels.UserCategoryArray>().map(String(data: response.content!, encoding:NSUTF8StringEncoding)!)?.categories![0];
                if (category!.getImageUrl().characters.count != 0){
                    Nuke.taskWith(NSURL(string: category!.getImageUrl())!){
                        self.hero.image = $0.image;
                    }.resume();
                }
            }
        }
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
