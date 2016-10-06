//
//  NSLayoutConstraintExtension.swift
//  Compass
//
//  Created by Ismael Alonso on 10/5/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


extension NSLayoutConstraint{
    func belongsTo(view: UIView) -> Bool{
        return firstItem === view || secondItem === view;
    }
}
