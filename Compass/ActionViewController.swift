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
    var upcomingAction: UpcomingAction? = nil;
    var mappingId: Int = -1;
    
    //UI components
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var masterContainer: UIView!
    @IBOutlet weak var hero: UIImageView!
    @IBOutlet var actionContainer: UIView!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var behaviorTitle: UILabel!
    @IBOutlet weak var actionDescription: UILabel!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet var rewardContainer: UIView!
    @IBOutlet weak var rewardHeader: UILabel!
    @IBOutlet weak var rewardContent: UILabel!
    @IBOutlet var rewardAuthor: UILabel!
    
    var actionConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    var rewardConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    var authorConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    
    
    override func viewDidLoad(){
        //Backup the constraints
        for constraint in masterContainer.constraints{
            if (constraint.firstItem === rewardContainer || constraint.secondItem === rewardContainer){
                rewardConstraints.append(constraint);
            }
            else if (constraint.firstItem === actionContainer || constraint.secondItem === actionContainer){
                actionConstraints.append(constraint);
            }
        }
        for constraint in rewardContainer.constraints{
            if (constraint.firstItem === rewardAuthor || constraint.secondItem === rewardAuthor){
                authorConstraints.append(constraint);
            }
        }
        
        //Remove all items from the master containes (except for the header) and the author
        actionContainer.removeFromSuperview();
        rewardContainer.removeFromSuperview();
        rewardAuthor.removeFromSuperview();
        
        //Either the mappingId is set or the upcomingAction is set (xor), select the propper mappingId
        if (upcomingAction != nil){
            laterButton.hidden = true;
            mappingId = upcomingAction!.getId();
        }
        
        //Fetch the action
        Just.get(API.getActionUrl(mappingId), headers: SharedData.getUser()!.getHeaderMap()) { (response) in
            if (response.ok){
                //Parse and populate
                let action = Mapper<UserAction>().map(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.actionTitle.text = action!.getTitle();
                    self.behaviorTitle.text = action!.getBehaviorTitle();
                    self.actionDescription.text = action!.getDescription();
                    self.masterContainer.addSubview(self.actionContainer);
                    self.masterContainer.addConstraints(self.actionConstraints);
                    self.masterContainer.setNeedsLayout();
                    self.masterContainer.layoutIfNeeded();
                    self.scrollView.contentSize = self.masterContainer.frame.size;
                });
                
                //Fetch the hero
                let category = SharedData.getCategory(action!.getPrimaryCategoryId());
                if (category != nil && category!.getImageUrl().characters.count != 0){
                    Nuke.taskWith(NSURL(string: category!.getImageUrl())!){
                        self.hero.image = $0.image;
                        }.resume();
                }
                //Fetch the reward
                self.fetchReward();
            }
        };
    }
    
    private func fetchCategory(categoryId: Int){
        Just.get(API.getUserCategoryUrl(categoryId), headers: SharedData.getUser()!.getHeaderMap()) { (response) in
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
    
    private func fetchReward(){
        Just.get(API.getRandomRewardUrl()){ (response) in
            if (response.ok){
                print("Reward retrieved");
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                let rewardContent = (Mapper<ParserModels.RewardArray>().map(result)?.rewards![0])!;
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.rewardHeader.text = rewardContent.getHeaderTitle();
                    self.rewardContent.text = rewardContent.getMessage();
                    self.masterContainer.addSubview(self.rewardContainer);
                    self.masterContainer.addConstraints(self.rewardConstraints);
                    if (rewardContent.isQuote()){
                        self.rewardAuthor.text = rewardContent.getAuthor();
                        self.rewardContainer.addSubview(self.rewardAuthor);
                        self.rewardContainer.addConstraints(self.authorConstraints);
                    }
                    self.rewardContainer.setNeedsLayout();
                    self.rewardContainer.layoutIfNeeded();
                    self.masterContainer.setNeedsLayout();
                    self.masterContainer.layoutIfNeeded();
                    self.scrollView.contentSize = self.masterContainer.frame.size;
                });
            }
        }
    }
    
    @IBAction func later(){
        
    }
    
    @IBAction func gotIt(){
        Just.post(API.getPostActionReportUrl(mappingId), json: API.getPostActionReportBody("completed"),
                  headers: SharedData.getUser()!.getHeaderMap());
        if (navigationController != nil){
            navigationController!.popViewControllerAnimated(true);
        }
    }
}
