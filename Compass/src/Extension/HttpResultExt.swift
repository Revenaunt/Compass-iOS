//
//  HttpResultExt.swift
//  Compass
//
//  Created by Ismael Alonso on 10/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation
import Just


extension Just.HTTPResult{
    var contentStr: String{
        get{
            return String(data: content!, encoding:NSUTF8StringEncoding)!;
        }
    }
}
