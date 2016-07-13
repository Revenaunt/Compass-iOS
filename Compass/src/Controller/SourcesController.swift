//
//  SourcesController.swift
//  Compass
//
//  Created by Ismael Alonso on 7/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class SourcesController: UITableViewController{
    private var sources: [Source] = [Source]();
    
    
    override func viewDidLoad(){
        sources.removeAll();
        sources.append(Source(caption: "\"Stay strong with Compass\" messaging inspired by the work of the Character Lab. Thanks, Dr. Duckworth!", url: "https://characterlab.org/resources"));
        sources.append(Source(caption: "Illustrations: Michael Cook (Cookicons)", url: "http://cookicons.co"));
        sources.append(Source(caption: "Icons: designed by flaticon", url: "http://www.flaticon.com"));
        sources.append(Source(caption: "Just", url: "https://github.com/justhttp/Just"));
        sources.append(Source(caption: "Object Mapper", url: "https://github.com/Hearst-DD/ObjectMapper"));
        sources.append(Source(caption: "Locksmith", url: "https://github.com/matthewpalmer/Locksmith/"));
        sources.append(Source(caption: "Nuke", url: "https://github.com/kean/Nuke"));
        
        
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("Sources \(sources.count)");
        return sources.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SourceCell", forIndexPath: indexPath) as! SourceCell;
        cell.bind(sources[indexPath.row]);
        return cell;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 200;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        UIApplication.sharedApplication().openURL(NSURL(string: sources[indexPath.row].getUrl())!);
    }
    
    
    class Source{
        private var caption: String;
        private var url: String;
        
        
        init(caption: String, url: String){
            self.caption = caption;
            self.url = url;
        }
        
        func getCaption() -> String{
            return caption;
        }
        
        func getUrl() -> String{
            return url;
        }
    }
}
