//
//  NSDateExt.swift
//  Compass
//
//  Created by Ismael Alonso on 10/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


extension NSDate: Comparable{ }


public func < (lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

func == (lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}
