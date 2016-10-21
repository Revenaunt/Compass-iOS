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
import Crashlytics


class AwardsController: UIViewController{
    //MARK: Data
    private var badges = [Badge]()
    private var badgeQueue = [Badge]()
    private var displaying = false
    
    //MARK: UI components
    @IBOutlet weak var noAwards: UILabel!
    @IBOutlet weak var loadingAwards: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Refresh
        refreshControl.addTarget(
            self,
            action: #selector(refresh(_:)),
            forControlEvents: .ValueChanged
        )
        tableView.addSubview(refreshControl)
        
        print(DefaultsManager.getNewAwardArray())
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navigationBarHeight = navigationController!.navigationBar.frame.size.height
        let top = statusBarHeight + navigationBarHeight
        
        tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        //Fetch every time the user access the controller if there are no awards
        if badges.isEmpty{
            fetchAwards(false)
        }
        else{
            //If there are awards, make sure the table is showing
            loadingAwards.hidden = true
            noAwards.hidden = true
            tableView.hidden = false
            
            //If there are badges in the queue add them and clear the queue
            if !badgeQueue.isEmpty{
                var indexPaths = [NSIndexPath]()
                for badge in badgeQueue{
                    badges.append(badge)
                    indexPaths.append(NSIndexPath(forRow: badges.count-1, inSection: 0))
                }
                badgeQueue.removeAll()
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
        }
        displaying = true
    }
    
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        displaying = false
    }
    
    
    //MARK: Fetch and refresh
    
    func refresh(refreshControl: UIRefreshControl){
        fetchAwards(true)
    }
    
    private func fetchAwards(refreshing: Bool){
        //Show the activity indicator if nor refreshing
        if !refreshing{
            tableView.hidden = true
            noAwards.hidden = true
            loadingAwards.hidden = false
        }
        
        //Fetch the user's awards
        Just.get(API.getAwardsUrl(), headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                let awardList = Mapper<AwardList>().map(response.contentStr)!
                if !awardList.awards.isEmpty{
                    let newAwards = DefaultsManager.getNewAwardArray()
                    self.badges.removeAll()
                    for award in awardList.awards{
                        let badge = award.getBadge()
                        badge.isNew = newAwards.contains(badge.getId())
                        self.badges.append(badge)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        if refreshing{
                            self.refreshControl.endRefreshing()
                        }
                        else{
                            self.loadingAwards.hidden = true
                            self.tableView.hidden = false
                        }
                        print(self.tableView.numberOfRowsInSection(0))
                        self.tableView.reloadData()
                    })
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        if refreshing{
                            self.refreshControl.endRefreshing()
                        }
                        else{
                            self.loadingAwards.hidden = true
                            self.noAwards.hidden = false
                        }
                    })
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), {
                    if refreshing{
                        self.refreshControl.endRefreshing()
                    }
                    else{
                        self.loadingAwards.hidden = true
                        self.noAwards.hidden = false
                    }
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let selectedCell = sender as? AwardCell{
            if segue.identifier == "BadgeFromAwards"{
                let badgeController = segue.destinationViewController as! BadgeController
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let badge = badges[indexPath.row]
                if badge.isNew{
                    badge.isNew = false
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
                badgeController.badge = badge
            }
        }
    }
    
    func addBadge(badge: Badge){
        if badges.contains(badge){
            badges.filter{ $0 == badge }[0].isNew = true
            tableView.reloadData()
        }
        else if !badges.isEmpty{
            if displaying{
                badges.append(badge)
                let paths = [NSIndexPath(forRow: badges.count-1, inSection: 0)]
                tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
            }
            else{
                badgeQueue.append(badge)
            }
        }
    }
}

extension AwardsController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return badges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AwardCell", forIndexPath: indexPath) as! AwardCell
        cell.bind(badges[indexPath.row])
        if badges[indexPath.row].isNew{
            DefaultsManager.removeNewAward(badges[indexPath.row])
            let newAwardCount = DefaultsManager.getNewAwardCount()
            if newAwardCount == 0{
                tabBarController!.tabBar.items?[2].badgeValue = nil
            }
            else{
                tabBarController!.tabBar.items?[2].badgeValue = "\(newAwardCount)"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
}
