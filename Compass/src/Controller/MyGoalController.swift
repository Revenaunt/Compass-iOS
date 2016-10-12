//
//  MyGoalController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/12/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper


class MyGoalController: UIViewController{
    //MARK: Data
    
    var userGoalId: Int!
    var userGoal: UserGoal? = nil
    
    //MARK: UI components
    @IBOutlet weak var hero: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    
    
    //MARK: Initial load methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if userGoal == nil{
            fetchGoal()
        }
        else{
            populateUI()
        }
    }
    
    private func fetchGoal(){
        let headerMap = SharedData.user.getHeaderMap()
        Just.get(API.URL.getUserGoal(userGoalId), headers: headerMap){ (response) in
            if response.ok{
                self.userGoal = Mapper<UserGoal>().map(response.contentStr)
                dispatch_async(dispatch_get_main_queue(), {
                    self.populateUI()
                })
            }
            else{
                
            }
        }
    }
    
    private func populateUI(){
        
    }
}
