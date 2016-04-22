//
//  GoalLibraryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class GoalLibraryViewController: UITableViewController{
    var category: CategoryContent? = nil;
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.tableView.bounces = false;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 4;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("Section: \(section)");
        if (section == 2){
            return 4
        }
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell;
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("HeaderHeroCell", forIndexPath: indexPath);
        }
        else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("CategoryDescriptionCell", forIndexPath: indexPath);
            let instance = cell as! CategoryDescriptionCell;
            instance.setCategory(category!);
        }
        else if (indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("GoalCell", forIndexPath: indexPath);
            let instance = cell as! GoalCell;
            instance.setContent(nil, category: category!);
        }
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("ProgressCell", forIndexPath: indexPath);
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        print("Height for: \(indexPath.section), \(indexPath.row)");
        if (indexPath.section == 0){
            return UIScreen.mainScreen().bounds.width*2/3;
        }
        else if (indexPath.section == 1){
            let title = category!.getTitle().heightWithConstrainedWidth(UIScreen.mainScreen().bounds.width, font: UIFont.boldSystemFontOfSize(17));
            let description = category!.getDescription().heightWithConstrainedWidth(UIScreen.mainScreen().bounds.width, font: UIFont.systemFontOfSize(17));
            return title+description+50;
        }
        else if (indexPath.section == 2){
            return 100;
        }
        else{
            return 50;
        }
    }
}
    
extension String{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
