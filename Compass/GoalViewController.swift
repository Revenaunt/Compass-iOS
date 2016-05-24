//
//  GoalViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 5/23/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Nuke


class GoalViewController: UIViewController{
    //Data
    var category: CategoryContent?;
    var goal: GoalContent?;
    
    //UI components
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    
    @IBOutlet weak var additionalSectionTitle: UILabel!
    @IBOutlet weak var additionalSectionContent: UILabel!
    
    
    override func viewDidLoad(){
        //Background color of the header
        header.layer.backgroundColor = category!.getParsedColor().CGColor;
        
        //Header image
        if (category!.getIconUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: category!.getIconUrl())!){
                let image = $0.image;
                self.headerImage.layer.cornerRadius = self.headerImage.frame.height/2;
                self.headerImage.clipsToBounds = true;
                self.headerImage.image = image;
                }.resume();
        }
        
        goalTitle.text = goal?.getTitle();
        goalDescription.text = goal?.getDescription();
    }
}
