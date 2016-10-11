//
//  StringExt.swift
//  Compass
//
//  Created by Ismael Alonso on 10/10/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


extension String{
    func chopAt(index: Int) -> String{
        let back = index-characters.count
        let indexObject = endIndex.advancedBy(back)
        return substringToIndex(indexObject)
    }
}
