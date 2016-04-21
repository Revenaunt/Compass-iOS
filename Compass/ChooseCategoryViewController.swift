//
//  ChooseCategoryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class ChooseCategoryViewController: UITableViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Data.getPublicCategories()!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell;
        cell.setCategory(Data.getPublicCategories()![indexPath.item]);
        return cell;
    }
}