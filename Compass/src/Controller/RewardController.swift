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
    @IBOutlet weak var icon: UIImageView!
    
    private var reward: Reward? = nil;
    
    
    override func viewDidLoad(){
        if (reward == nil){
            Just.get(API.getRandomRewardUrl()){ (response) in
                if (response.ok){
                    let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                    self.reward = Mapper<ParserModels.RewardArray>().map(result)?.rewards![0];
                    print(self.reward!);
                    dispatch_async(dispatch_get_main_queue(), {
                        self.icon.layoutIfNeeded();
                        self.icon.image = self.reward?.getImageAsset();
                    });
                }
            }
        }
    }
}
