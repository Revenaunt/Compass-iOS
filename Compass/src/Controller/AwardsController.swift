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
    private var awards: [Award] = [Award]();
    
    override func viewDidLoad(){
        Just.get(API.getAwardsUrl(), headers: SharedData.user.getHeaderMap()){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                let aa = Mapper<ParserModels.AwardArray>().map(result)!;
                if (aa.awards != nil){
                    self.awards = aa.awards!;
                }
                var paths = [NSIndexPath]();
                for i in 0...self.awards.count-1{
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
        return awards.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AwardCell", forIndexPath: indexPath) as! AwardCell;
        cell.bind(awards[indexPath.row].badge!);
        return cell;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let selectedCell = sender as? AwardCell{
            if (segue.identifier == "ShowBadge"){
                let badgeController = segue.destinationViewController as! BadgeController;
                let indexPath = tableView.indexPathForCell(selectedCell);
                badgeController.badge = awards[indexPath!.row].badge;
            }
        }
    }
}
