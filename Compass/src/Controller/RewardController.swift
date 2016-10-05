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


class RewardController: UIViewController{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentCard: UIView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet var author: UILabel!
    
    private var reward: Reward? = nil;
    private var authorConstraints = [NSLayoutConstraint]();
    
    
    override func viewDidLoad(){
        contentCard.layer.cornerRadius = 4;
        removeAuthorLabel();
        if (reward == nil){
            fetchReward();
        }
        else{
            setReward(reward!);
        }
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
}
