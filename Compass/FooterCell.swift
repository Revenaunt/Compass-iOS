//
//  FooterCell.swift
//  Compass
//
//  Created by Ismael Alonso on 6/2/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class FooterCell: UITableViewCell{
    var delegate: MainViewController? = nil;
    var type: FooterType? = nil;
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    @IBAction func seeMore(){
        if (type == FooterType.Upcoming){
            delegate?.loadMoreUpcoming();
        }
        else if (type == FooterType.Goals){
            seeMoreButton.hidden = true;
            activity.hidden = false;
            delegate?.loadMoreGoals(self);
        }
    }
    
    func bind(delegate: MainViewController, type: FooterType){
        self.delegate = delegate;
        self.type = type;
    }
    
    func end(){
        seeMoreButton.hidden = false;
        activity.hidden = true;
    }
    
    
    enum FooterType{
        case Upcoming, Goals;
    }
}
