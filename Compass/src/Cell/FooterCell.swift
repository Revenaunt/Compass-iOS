//
//  FooterCell.swift
//  Compass
//
//  Created by Ismael Alonso on 6/2/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class FooterCell: UITableViewCell{
    private var delegate: FeedController!;
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    @IBAction func seeMore(){
        seeMoreButton.hidden = true;
        activity.hidden = false;
        activity.startAnimating();
        delegate.loadMoreGoals(self);
    }
    
    func bind(delegate: FeedController){
        self.delegate = delegate;
        seeMoreButton.hidden = false;
        activity.hidden = true;
    }
    
    func end(){
        seeMoreButton.hidden = false;
        activity.hidden = true;
    }
}
