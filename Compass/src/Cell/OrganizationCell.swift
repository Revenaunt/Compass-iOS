//
//  OrganizationCell.swift
//  Compass
//
//  Created by Ismael Alonso on 8/8/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class OrganizationCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    
    
    func setOrganization(organization: Organization){
        name.text = organization.getName();
    }
}
