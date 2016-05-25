//
//  GoalLibraryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper
import Nuke


class GoalLibraryViewController: UITableViewController, GoalAddedDelegate{
    var category: CategoryContent? = nil;
    
    private var goals = [GoalContent]();
    private var activityCell: UITableViewCell? = nil;
    
    private var loading: Bool = false;
    private var next: String? = nil;
    
    private var selectedGoal: GoalContent? = nil;
    private var goalWasAdded = false;
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.tableView.bounces = false;
        
        //Load first batch of goalz
        next = API.getGoalsUrl(category!);
        loadMore();
    }
    
    override func viewDidAppear(animated: Bool){
        //if we come from a child view controller (as opposed to the parent)
        if (selectedGoal != nil){
            if (goalWasAdded){
                print("the goal is marked as added");
            }
        }
    }
    
    private func loadMore(){
        loading = true;
        Just.get(next!){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                let gca = Mapper<ParserModels.GoalContentArray>().map(result)!;
                let start = self.goals.count;
                self.goals.appendContentsOf(gca.goals!);
                self.next = gca.next;
                if (API.STAGING && self.next != nil && (self.next?.hasPrefix("https"))!){
                    self.next = "http" + (self.next?.substringFromIndex((self.next?.startIndex.advancedBy(5))!))!;
                }
                var paths = [NSIndexPath]();
                for i in 0...gca.goals!.count-1{
                    paths.append(NSIndexPath(forRow: start+i, inSection: 2));
                }
                print("Next url: \(self.next)");
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.beginUpdates()
                    if (self.next == nil){
                        self.tableView.deleteSections(NSIndexSet(index: 3), withRowAnimation: .Automatic);
                    }
                    self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic);
                    self.tableView.endUpdates();
                });
            }
            self.loading = false;
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if (next == nil){
            return 3;
        }
        return 4;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("Section: \(section)");
        if (section == 2){
            return goals.count;
        }
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell;
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("HeaderHeroCell", forIndexPath: indexPath);
            let instance = cell as! CategoryHeaderCell;
            instance.setHeader(category!);
        }
        else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("CategoryDescriptionCell", forIndexPath: indexPath);
            let instance = cell as! CategoryDescriptionCell;
            instance.setCategory(category!);
        }
        else if (indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("GoalCell", forIndexPath: indexPath);
            let instance = cell as! GoalCell;
            instance.setContent(goals[indexPath.row], category: category!);
            
        }
        else{
            if (activityCell == nil){
                cell = tableView.dequeueReusableCellWithIdentifier("ProgressCell", forIndexPath: indexPath);
                activityCell = cell;
            }
            else{
                cell = activityCell!;
            }
            if (!loading && next != nil){
                loadMore();
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let selectedCell = sender as? GoalCell{
            if (segue.identifier == "ShowGoalFromLibrary"){
                let goalController = segue.destinationViewController as! GoalViewController;
                let indexPath = tableView.indexPathForCell(selectedCell);
                selectedGoal = goals[indexPath!.row];
                goalWasAdded = false;
                goalController.delegate = self;
                goalController.category = category!;
                goalController.goal = selectedGoal;
            }
        }
    }
    
    func goalAdded(){
        goalWasAdded = true;
    }
}

