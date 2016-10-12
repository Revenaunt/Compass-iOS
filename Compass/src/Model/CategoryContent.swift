//
//  CategoryContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import ObjectMapper


class CategoryContent: TDCContent, CustomStringConvertible{
    private var order: Int = -1
    
    private var imageUrl: String = ""
    private var color: String = ""
    private var secondaryColor: String = ""
    
    private var packagedContent: Bool = false
    private var group: Int = -1
    private var groupName: String = ""
    private var selectedByDefault: Bool = false
    
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        order <- map["order"]
        imageUrl <- map["image_url"]
        color <- map["color"]
        secondaryColor <- map["secondary_color"]
        packagedContent <- map["packaged_content"]
        group <- map["grouping"]
        groupName <- map["grouping_name"]
        selectedByDefault <- map["selected_by_default"]
    }
    
    
    //TODO getters
    
    func getImageUrl() -> String{
        return imageUrl
    }
    
    func getColor() -> String{
        return color
    }
    
    func getParsedColor() -> UIColor{
        return UIColor(hexString: color)
    }
    
    func isPackagedContent() -> Bool{
        return packagedContent
    }
    
    func getGroup() -> Int{
        return group
    }
    
    func getGroupName() -> String{
        return groupName
    }
    
    func isFeatured() -> Bool{
        return group != -1
    }
    
    func isSelectedByDefault() -> Bool{
        return selectedByDefault
    }
    
    var description: String{
        return "Category #\(getId()): \(getTitle())"
    }
}


class CategoryContentList: ListResult{
    private(set) internal var categories: [CategoryContent]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        categories <- map["results"]
    }
}
