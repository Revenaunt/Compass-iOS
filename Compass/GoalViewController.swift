//
//  GoalViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 5/23/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Nuke
import Just
import ObjectMapper


class GoalViewController: UIViewController{
    //Data
    var category: CategoryContent?;
    var goal: GoalContent?;
    
    var imageViewProcessed = false;
    
    //UI components
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet var rewardHeader: UILabel!
    @IBOutlet var reward: UILabel!
    @IBOutlet var author: UILabel!
    
    private var rewardHeaderConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    private var rewardConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    private var authorConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]();
    
    
    override func viewDidLoad(){
        //Background color of the header
        header.layer.backgroundColor = category!.getParsedColor().CGColor;
        
        //Header image
        if (category!.getIconUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: category!.getIconUrl())!){
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
        goalTitle.text = goal?.getTitle();
        goalDescription.text = goal?.getDescription();
        
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
                    self.contentContainer.layoutIfNeeded();
                });
            }
        }
    }
}
