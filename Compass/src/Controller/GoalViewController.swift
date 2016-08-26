//
//  GoalViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 5/23/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke
import Just
import ObjectMapper
import Instructions


class GoalViewController: UIViewController, UIScrollViewDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    //Delegate
    var delegate: GoalAddedDelegate!;
    
    //Data
    var category: CategoryContent!;
    var goal: GoalContent!;
    var userGoal: UserGoal? = nil;
    var fromFeed = false;   // Are we launching this from the feed?
    
    var imageViewProcessed = false;
    
    //UI components
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var signMeUpButton: UIButton!
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet var rewardHeader: UILabel!
    @IBOutlet var reward: UILabel!
    @IBOutlet var author: UILabel!
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var removeButton: UIButton!
    
    private var rewardHeaderConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    private var rewardConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    private var authorConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    
    private let coachMarksController = CoachMarksController();
    
    
    override func viewDidLoad(){
        //Background color of the header
        header.layer.backgroundColor = category.getParsedColor().CGColor;
        
        //Header image
        if (category.getIconUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: category.getIconUrl())!){
                //For some reason, in the second run, the frame object reports a wrong height,
                //  to fix that, header image is forced to layout to calculate the actual
                //  height respecting its constraints, and only then we set the corner radius
                self.headerImage.setNeedsLayout();
                self.headerImage.layoutIfNeeded();
                self.headerImage.layer.cornerRadius = self.headerImage.frame.height/2;
                self.headerImage.clipsToBounds = true;
                self.headerImage.image = $0.image;
            }.resume();
        }
        
        //Goal information
        goalTitle.text = goal.getTitle();
        goalDescription.text = goal.getDescription();
        
        // If we're showing this goal from the feed, the user has already
        // selected the goal, so we don't need to display these buttons
        if (fromFeed){
            buttonContainer.hidden = true;
            removeButton.hidden = false;
        }
        
        //Reward content
        //Extract the relevant constraints before they get removed
        for constraint in contentContainer.constraints{
            //Author constraints need to go all in the author array, because author may not be
            //  added back to the container
            if (constraint.firstItem === author || constraint.secondItem === author){
                authorConstraints.append(constraint);
                continue;
            }
            if (constraint.firstItem === rewardHeader || constraint.secondItem === rewardHeader){
                rewardHeaderConstraints.append(constraint);
                continue;
            }
            if (constraint.firstItem === reward || constraint.secondItem === reward){
                rewardConstraints.append(constraint);
            }
        }
        
        //Remove the reward related views and fetch the reward
        rewardHeader.removeFromSuperview();
        reward.removeFromSuperview();
        author.removeFromSuperview();
        Just.get(API.getRandomRewardUrl()){ (response) in
            if (response.ok){
                print("Reward retrieved");
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                let rewardContent = (Mapper<ParserModels.RewardArray>().map(result)?.rewards![0])!;
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.contentContainer.addSubview(self.rewardHeader);
                    self.contentContainer.addSubview(self.reward);
                    self.contentContainer.addConstraints(self.rewardHeaderConstraints);
                    self.contentContainer.addConstraints(self.rewardConstraints);
                    self.rewardHeader.text = rewardContent.getHeaderTitle();
                    self.reward.text = rewardContent.getMessage();
                    if (rewardContent.isQuote()){
                        self.contentContainer.addSubview(self.author);
                        self.contentContainer.addConstraints(self.authorConstraints);
                        self.author.text = rewardContent.getAuthor();
                    }
                    self.contentContainer.setNeedsLayout();
                    self.contentContainer.layoutIfNeeded();
                    self.scrollView.contentSize = self.contentContainer.frame.size;
                });
            }
        }
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlayBackgroundColor = UIColor.clearColor();
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated);
        
        let container = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height);
        if (CGRectIntersectsRect(signMeUpButton.frame, container)){
            self.coachMarksController.startOn(self);
        }
        else{
            scrollView.scrollRectToVisible(signMeUpButton.frame, animated: true);
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView){
        self.coachMarksController.startOn(self);
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, decelerate: Bool){
        self.scrollView.contentSize = self.contentContainer.frame.size;
    }
    
    @IBAction func notNow(){
        navigationController!.popViewControllerAnimated(true);
    }
    
    @IBAction func yesImIn(){
        delegate.goalAdded();
        navigationController!.popViewControllerAnimated(true);
    }
    
    @IBAction func remove(){
        if (userGoal != nil){
            Just.delete(API.URL.deleteGoal(userGoal!), headers: SharedData.user.getHeaderMap()){ (response) in
                
            };
            SharedData.feedData.removeGoal(userGoal!);
            navigationController!.popViewControllerAnimated(true);
        }
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        if (fromFeed){
            return 0;
        }
        return TourManager.getGoalMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex: Int) -> CoachMark{
        switch (TourManager.getFirstUnseenGoalMarker()){
        case .Add:
            var mark = coachMarksController.coachMarkForView(signMeUpButton);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlayBackgroundColor = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        default:
            break;
        }
        return coachMarksController.coachMarkForView();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
        switch (TourManager.getFirstUnseenGoalMarker()){
        case .Add:
            coachViews.bodyView.hintLabel.text = "Tap \"SIGN ME UP\" to begin receiving Compass tips.";
            coachViews.bodyView.nextLabel.text = "OK";
            coachViews.arrowView = nil;
            
        default:
            break;
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int){
        TourManager.markFirstUnseenGoalMarker();
    }
}

protocol GoalAddedDelegate{
    func goalAdded();
}
