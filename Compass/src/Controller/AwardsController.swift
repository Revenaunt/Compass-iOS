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
                    let newAwards = DefaultsManager.getNewAwardArray();
                    self.badges.removeAll();
                    for (award) in aa.awards!{
                        let badge = award.badge!
                        badge.isNew = newAwards.contains(badge.getId());
                        self.badges.append(badge);
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
        if (badges[indexPath.row].isNew){
            DefaultsManager.removeNewAward(badges[indexPath.row]);
            let newAwardCount = DefaultsManager.getNewAwardCount();
            if (newAwardCount == 0){
                tabBarController!.tabBar.items?[2].badgeValue = nil;
            }
            else{
                tabBarController!.tabBar.items?[2].badgeValue = "\(newAwardCount)";
            }
        }
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
                let indexPath = tableView.indexPathForCell(selectedCell)!;
                let badge = badges[indexPath.row];
                badge.isNew = false;
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic);
                badgeController.badge = badge;
            }
        }
    }
    
    func addBadge(badge: Badge){
        if (badges.contains(badge)){
            badges.filter{ $0 == badge }[0].isNew = true;
            tableView.reloadData();
        }
        else{
            badges.append(badge);
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: badges.count-1, inSection: 0)], withRowAnimation: .Automatic);
        }
    }
}
