//
//  OrganizationsController.swift
//  Compass
//
//  Created by Ismael Alonso on 8/8/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit;
import Just;
import ObjectMapper;


class OrganizationsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var explanation: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var error: UILabel!
    
    var organizations: [Organization] = [Organization]();
    
    
    override func viewDidLoad(){
        explanation.textContainerInset = UIEdgeInsetsMake(14, 20, 14, 20);
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        loadData();
    }
    
    private func loadData(){
        Just.get(API.URL.getOrganizations()){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                print(result);
                let orgArray = Mapper<ParserModels.OrganizationArray>().map(result)!;
                self.organizations = orgArray.organizations!;
                print(self.organizations.count);
                dispatch_async(dispatch_get_main_queue(), {
                    self.progress.hidden = true;
                    self.tableView.hidden = false;
                    self.tableView.reloadData();
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.error.hidden = false;
                    self.progress.hidden = false;
                    self.tableView.hidden = false;
                });
            }
        };
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return organizations.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "";
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("OrganizationCell", forIndexPath: indexPath) as! OrganizationCell;
        cell.setOrganization(organizations[indexPath.row]);
        return cell;
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.hidden = true;
        progress.hidden = false;
        progress.startAnimating();
        
        Just.post(API.URL.postOrganization(), headers: SharedData.user.getHeaderMap(),
                  json: API.BODY.postOrganization(organizations[indexPath.row])){ (response) in
            
            if (response.ok){
                print("Posted org");
                Just.get(API.getCategoriesUrl(), headers: SharedData.user.getHeaderMap()){ (response) in
                    if (response.ok){
                        print("Fetched cats");
                        let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                        let categoryArray = Mapper<ParserModels.CategoryContentArray>().map(result);
                        SharedData.publicCategories = (categoryArray?.categories)!;
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.transitionToCategories();
                        });
                    }
                };
            }
            else{
                print(response.statusCode);
                print(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
            }
        };
    }
    
    @IBAction func retry(sender: UITapGestureRecognizer){
        error.hidden = true;
        progress.hidden = false;
        loadData();
    }
    
    @IBAction func skip(){
        transitionToCategories();
    }
    
    private func transitionToCategories(){
        navigationController!.popViewControllerAnimated(false);
        performSegueWithIdentifier("categoriesFromOrganizations", sender: nil);
    }
}