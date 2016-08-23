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


class ActionViewController: UIViewController{
    //Data
    var delegate: ActionDelegate? = nil;
    var upcomingAction: UpcomingAction? = nil;
    var notificationId: Int = -1;
    var mappingId: Int = -1;
    var behaviorDescription: String = ""
    var behaviorTitle: String = ""
    
    //UI components
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var masterContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var hero: UIImageView!
    @IBOutlet var actionTitle: UILabel!
    @IBOutlet var behaviorButton: UIButton!
    @IBOutlet var actionDescription: UILabel!
    @IBOutlet var buttonContainer: UIView!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet var rewardHeader: UILabel!
    @IBOutlet var rewardContent: UILabel!
    @IBOutlet var rewardAuthor: UILabel!
    
    var actionConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    var rewardConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    var authorConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    

    override func viewDidLoad(){
        //Backup the constraints
        for constraint in masterContainer.constraints{
            if (belongsTo(constraint, view: imageContainer) || belongsTo(constraint, view: hero)){
                if (belongsTo(constraint, view: actionTitle)){
                    actionConstraints.append(constraint);
                }
            }
            else if (belongsTo(constraint, view: rewardAuthor)){
                authorConstraints.append(constraint);
            }
            else if (belongsTo(constraint, view: rewardHeader) || belongsTo(constraint, view: rewardContent)){
                rewardConstraints.append(constraint);
            }
            else{
                actionConstraints.append(constraint);
            }
        }
        
        //Remove all items from the master containes (except for the header) and the author
        actionTitle.removeFromSuperview();
        behaviorButton.removeFromSuperview();
        actionDescription.removeFromSuperview();
        buttonContainer.removeFromSuperview();
        rewardHeader.removeFromSuperview();
        rewardContent.removeFromSuperview();
        rewardAuthor.removeFromSuperview();
        
        //Either the mappingId is set or the upcomingAction is set (xor), select the propper mappingId
        if (upcomingAction != nil){
            laterButton.hidden = true;
            mappingId = upcomingAction!.getId();
        }
        
        //Fetch the action
        Just.get(API.getActionUrl(mappingId), headers: SharedData.user.getHeaderMap()) { (response) in
            if (response.ok){
                //Parse and populate
                print(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
                let action = Mapper<UserAction>().map(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.actionTitle.text = action!.getTitle();
                    self.behaviorTitle = action!.getBehaviorTitle();
                    self.behaviorButton.setTitle(action!.getBehaviorTitle(), forState: UIControlState.Normal);
                    self.behaviorDescription = action!.getBehaviorDescription();
                    self.actionDescription.text = action!.getDescription();
                    
                    self.masterContainer.addSubview(self.actionTitle);
                    self.masterContainer.addSubview(self.behaviorButton);
                    self.masterContainer.addSubview(self.actionDescription);
                    self.masterContainer.addSubview(self.buttonContainer);
                    self.masterContainer.addConstraints(self.actionConstraints);
                    self.masterContainer.setNeedsLayout();
                    self.masterContainer.layoutIfNeeded();
                    self.scrollView.contentSize = self.masterContainer.frame.size;
                    
                    //Fetch the reward
                    self.fetchReward();
                });
                //Fetch the hero
                let category = SharedData.getCategory(action!.getPrimaryCategoryId());
                if (category != nil && category!.getImageUrl().characters.count != 0){
                    Nuke.taskWith(NSURL(string: category!.getImageUrl())!){
                        print("Image loaded, onload");
                        self.hero.image = $0.image;
                        dispatch_async(dispatch_get_main_queue(), {
                            self.masterContainer.setNeedsLayout();
                            self.masterContainer.layoutIfNeeded();
                        });
                    }//.resume();
                }
            }
        };
    }
    
    private func belongsTo(constraint: NSLayoutConstraint, view: UIView) -> Bool{
        return constraint.firstItem === view || constraint.secondItem === view;
    }
    
    @IBAction func displayBehaviorDetails(sender: AnyObject) {
        //let alertController = UIAlertController(title: behaviorTitle, message: behaviorDescription, preferredStyle: .ActionSheet)
        let alertController = UIAlertController(title: behaviorTitle, message: behaviorDescription, preferredStyle: .Alert)

        // HACK for changing the style of alerts. Note the comment about this being private API usage.
        // http://stackoverflow.com/a/26949674/182778

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        let messageText = NSMutableAttributedString(
            string: behaviorDescription,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
            ]
        )
        alertController.setValue(messageText, forKey: "attributedMessage")
        
        // Wire up OK action and present the alert.
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // OK doesn't do anything.
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // Neither does presenting the alert.
        }
    }
    
    private func fetchCategory(categoryId: Int){
        Just.get(API.getUserCategoryUrl(categoryId), headers: SharedData.user.getHeaderMap()) { (response) in
            if (response.ok){
                let category = Mapper<ParserModels.UserCategoryArray>().map(String(data: response.content!, encoding:NSUTF8StringEncoding)!)?.categories![0];
                if (category!.getImageUrl().characters.count != 0){
                    Nuke.taskWith(NSURL(string: category!.getImageUrl())!){
                        print("Image loaded");
                        self.hero.image = $0.image;
                    }.resume();
                }
            }
        }
    }
    
    private func fetchReward(){
        Just.get(API.getRandomRewardUrl()){ (response) in
            if (response.ok){
                print("Reward retrieved");
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                let rewardContent = (Mapper<ParserModels.RewardArray>().map(result)?.rewards![0])!;
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.rewardHeader.text = rewardContent.getHeaderTitle();
                    self.rewardContent.text = rewardContent.getMessage();
                    self.masterContainer.addSubview(self.rewardHeader);
                    self.masterContainer.addSubview(self.rewardContent);
                    self.masterContainer.addConstraints(self.rewardConstraints);
                    if (rewardContent.isQuote()){
                        self.rewardAuthor.text = rewardContent.getAuthor();
                        self.masterContainer.addSubview(self.rewardAuthor);
                        self.masterContainer.addConstraints(self.authorConstraints);
                    }
                    self.masterContainer.setNeedsLayout();
                    self.masterContainer.layoutIfNeeded();
                    self.scrollView.contentSize = self.masterContainer.frame.size;
                });
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
        Just.post(API.getPostActionReportUrl(mappingId), json: API.getPostActionReportBody("completed"),
                  headers: SharedData.user.getHeaderMap()){ response in
                    
        };
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
        
        Just.put(API.getPutSnoozeUrl(notificationId), json: API.getPutSnoozeBody(date, time: time),
                 headers: SharedData.user.getHeaderMap());
    }
}

protocol ActionDelegate{
    func onDidIt();
}
