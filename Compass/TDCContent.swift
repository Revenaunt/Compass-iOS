//
//  TDCContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class TDCContent: TDCBase{
    private var title: String = "";
    private var description: String = "";
    private var htmlDescription: String = "";
    private var iconUrl: String = "";
    
    
    func getTitle() -> String{
        return title;
    }
    
    func getDescription() -> String{
        return description;
    }
    
    func getHtmlDescription() -> String{
        return htmlDescription;
    }
    
    func getIconUrl() -> String{
        return iconUrl;
    }
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        title <- map["title"];
        description <- map["description"];
        htmlDescription <- map["html_description"];
        iconUrl <- map["icon_url"];
    }
}