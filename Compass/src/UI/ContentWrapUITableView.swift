//
//  ContentWrapUITable.swift
//  Compass
//
//  Created by Ismael Alonso on 10/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class ContentWrapUITableView: UITableView{
    override func intrinsicContentSize() -> CGSize{
        setNeedsLayout()
        layoutIfNeeded()
        return CGSizeMake(UIViewNoIntrinsicMetric, self.contentSize.height)
    }
}
