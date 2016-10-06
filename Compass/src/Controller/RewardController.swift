//
//  RewardController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/4/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper


class RewardController: UIViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentCard: UIView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    private var reward: Reward? = nil;
    private var authorConstraints = [NSLayoutConstraint]();
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        //Content card mods
        contentCard.layer.cornerRadius = 4;
        removeAuthorLabel();
        
        //Tap gestures for the buttons
        let refreshTap = UITapGestureRecognizer(target: self, action: #selector(RewardController.handleTap(_:)));
        refreshTap.delegate = self;
        refreshView.addGestureRecognizer(refreshTap);
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(RewardController.handleTap(_:)));
        shareTap.delegate = self;
        shareView.addGestureRecognizer(shareTap);
        
        //Decide whether the reward needs to be fetched
        if (reward == nil){
            fetchReward();
        }
        else{
            setReward(reward!);
        }
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated);
        
        //Make the buttons circumferences
        refreshView.layer.cornerRadius = refreshView.frame.width/2;
        shareView.layer.cornerRadius = shareView.frame.width/2;
    }
    
    private func removeAuthorLabel(){
        if authorConstraints.isEmpty{
            for constraint in contentCard.constraints{
                if constraint.belongsTo(author){
                    authorConstraints.append(constraint);
                }
            }
            author.removeFromSuperview();
            contentCard.setNeedsLayout();
            contentCard.layoutIfNeeded();
        }
    }
    
    private func addAuthorLabel(){
        if !authorConstraints.isEmpty{
            contentCard.addSubview(author);
            for constraint in authorConstraints{
                contentCard.addConstraint(constraint);
            }
            authorConstraints.removeAll();
            contentCard.setNeedsLayout();
            contentCard.layoutIfNeeded();
        }
    }
    
    private func fetchReward(){
        scrollView.hidden = true;
        loadingIndicator.hidden = false;
        removeAuthorLabel();
        Just.get(API.getRandomRewardUrl()){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                let reward = Mapper<ParserModels.RewardArray>().map(result)?.rewards![0];
                dispatch_async(dispatch_get_main_queue(), {
                    self.setReward(reward!);
                });
            }
        }
    }
    
    private func setReward(reward: Reward){
        scrollView.hidden = false;
        loadingIndicator.hidden = true;
        self.reward = reward;
        icon.image = reward.getImageAsset();
        header.text = reward.getHeaderTitle();
        message.text = reward.getMessage();
        if reward.isQuote(){
            addAuthorLabel();
            author.text = "-\(reward.getAuthor())";
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer?){
        if sender!.view == refreshView{
            fetchReward();
        }
        else if sender!.view == shareView{
            shareReward();
        }
    }
    
    private func shareReward(){
        let items = [reward!.description];
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil);
        presentViewController(controller, animated: true, completion: nil);
    }
}
