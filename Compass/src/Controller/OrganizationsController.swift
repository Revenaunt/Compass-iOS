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
import Instructions;


class OrganizationsController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    @IBOutlet weak var explanation: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    var organizations: [Organization] = [Organization]();
    
    private let coachMarksController = CoachMarksController();
    
    
    override func viewDidLoad(){
        if (TourManager.getOrganizationMarkerCount() != 0){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        }
        
        explanation.textContainerInset = UIEdgeInsetsMake(14, 20, 14, 20);
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlayBackgroundColor = UIColor.clearColor();
        
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
                    self.coachMarksController.startOn(self);
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
                    print(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
                    if (response.ok){
                        print("Fetched cats");
                        let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                        let categoryArray = Mapper<ParserModels.CategoryContentArray>().map(result);
                        SharedData.publicCategories = (categoryArray?.categories)!;
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.transitionToCategories();
                            self.tableView.hidden = false;
                            self.progress.hidden = true;
                        });
                    }
                };
            }
            else{
                print(response.statusCode);
                print(String(data: response.content!, encoding:NSUTF8StringEncoding)!);
            }
        };
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        return TourManager.getOrganizationMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex coachMarksForIndex: Int) -> CoachMark{
        switch (TourManager.getFirstUnseenOrganizationMarker()){
        case .General:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlayBackgroundColor = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        case .Skip:
            var mark = coachMarksController.coachMarkForView(skipButton);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        default:
            break;
        }
        return coachMarksController.coachMarkForView();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
        switch (TourManager.getFirstUnseenOrganizationMarker()){
        case .General:
            coachViews.bodyView.hintLabel.text = "Review this list and tap your organization name";
            coachViews.bodyView.nextLabel.text = "Next";
            coachViews.arrowView = nil;
            
        case .Skip:
            coachViews.bodyView.hintLabel.text = "Tap here if you want to skip";
            coachViews.bodyView.nextLabel.text = "OK";
            
        default:
            break;
        }
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            UIApplication.sharedApplication().endIgnoringInteractionEvents();
        });
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int){
        TourManager.markFirstUnseenOrganizationMarker();
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
