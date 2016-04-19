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
}
