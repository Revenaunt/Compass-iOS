//
//  CategoryContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import ObjectMapper


class CategoryContent: TDCContent{
    private var order: Int = -1;
    
    private var imageUrl: String = "";
    private var color: String = "";
    private var secondaryColor: String = "";
    
    private var packagedContent: Bool = false;
    private var featured: Bool = false;
    private var selectedByDefault: Bool = false;
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        order <- map["order"];
        imageUrl <- map["image_url"];
        color <- map["color"];
        secondaryColor <- map["secondary_color"];
        packagedContent <- map["packaged_content"];
        featured <- map["featured"];
        selectedByDefault <- map["selected_by_default"];
    }
    
    
    //TODO getters
    
    func getImageUrl() -> String{
        return imageUrl;
    }
    
    func getColor() -> String{
        return color;
    }
    
    func getParsedColor() -> UIColor{
        return UIColor(hexString: color);
    }
    
    func isPackagedContent() -> Bool{
        return packagedContent;
    }
    
    func isFeatured() -> Bool{
        return featured;
    }
    
    func isSelectedByDefault() -> Bool{
        return selectedByDefault;
    }
    
    func toString() -> String{
        return "Category #\(getId()): \(getTitle())";
    }
}

extension UIColor{
    public convenience init(hexString: String){
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#"){
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
            if hexColor.characters.count == 6 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber){
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 0);
    }
}
