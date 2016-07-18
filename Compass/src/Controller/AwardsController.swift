//
//  AwardsController.swift
//  Compass
//
//  Created by Ismael Alonso on 7/14/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper


class AwardsController: UITableViewController{
    private var badges: [Badge] = [Badge]();
    
    override func viewDidLoad(){
        Just.get(API.getAwardsUrl(), headers: SharedData.user.getHeaderMap()){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                let aa = Mapper<ParserModels.AwardArray>().map(result)!;
                if (aa.awards != nil){
                    self.badges.removeAll();
                    for (award) in aa.awards!{
                        self.badges.append(award.badge!);
                    }
                }
                var paths = [NSIndexPath]();
                for i in 0..<self.badges.count{
                    paths.append(NSIndexPath(forRow: i, inSection: 0));
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic);
                });
            }
        }
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return badges.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AwardCell", forIndexPath: indexPath) as! AwardCell;
        cell.bind(badges[indexPath.row]);
        return cell;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        segue.destinationViewController.hidesBottomBarWhenPushed = true;
        if let selectedCell = sender as? AwardCell{
            if (segue.identifier == "ShowBadge"){
                let badgeController = segue.destinationViewController as! BadgeController;
                let indexPath = tableView.indexPathForCell(selectedCell);
                badgeController.badge = badges[indexPath!.row];
            }
        }
    }
    
    func addBadge(badge: Badge){
        badges.append(badge);
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: badges.count-1, inSection: 0)], withRowAnimation: .Automatic);
    }
}
