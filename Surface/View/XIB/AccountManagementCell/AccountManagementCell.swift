//
//  AccountManagementCell.swift
//  BeautyKingdom
//
//  Created by appinventiv on 29/05/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class AccountManagementCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var checkBoxButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
