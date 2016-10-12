//
//  InitialDataLoader.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Just
import ObjectMapper


class InitialDataLoader{
    private static var user: User? = nil;
    private static var callback: ((Bool)) -> Void = { success in };
    
    static func load(user: User, callback: ((Bool)) -> Void){
        self.user = user;
        self.callback = callback;
        fetchCategories();
    }
    
    private static func fetchCategories(){
        Just.get(API.getCategoriesUrl(), headers: user!.getHeaderMap()){ (response) in
            if (response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!)){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                SharedData.publicCategories = (Mapper<ParserModels.CategoryContentArray>().map(result)?.categories)!;
                //for category in SharedData.publicCategories{
                //    print(category.toString());
                //}
                success();
            }
            else{
                failure();
            }
        }
    }
    
    private static func success(){
        dispatch_async(dispatch_get_main_queue(), {
            callback(true);
        });
    }
    
    private static func failure(){
        dispatch_async(dispatch_get_main_queue(), {
            callback(false);
        });
    }
}


