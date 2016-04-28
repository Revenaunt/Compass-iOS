//
//  CompassUtil.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//



class CompassUtil{
    static func isSuccessStatusCode(statusCode: Int) -> Bool{
        return statusCode >= 200 && statusCode < 300;
    }
    
    static func getCategoryTileAssetName(category: CategoryContent) -> String{
        switch (category.getTitle().lowercaseString){
            case "happiness & fun":
                return "Tile - Fun";
            
            case "family & parenting":
                return "Tile - Family";
            
            case "work & prosperity":
                return "Tile - Prosperity";
            
            case "home & safety":
                return "Tile - Home";
            
            case "education & skills":
                return "Tile - Skills";
            
            case "health & wellness":
                return "Tile - Health";
            
            case "community & friendship":
                return "Tile - Community";
            
            case "romance & relationships":
                return "Tile - Romance";
            
            default:
                return "Tile - Master";
        }
    }
    
    static func getHeaderMap(user: User) -> [String: String]{
        return ["Authorization": "Token " + user.getToken()];
    }
}
