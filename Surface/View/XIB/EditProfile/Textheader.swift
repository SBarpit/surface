//
//  Textheader.swift
//  Surface
//
//  Created by Arvind Rawat on 04/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class Textheader: UITableViewHeaderFooterView {

   
    @IBOutlet weak var headerInfoLabel: UILabel!

    override func awakeFromNib() {
        
        initialSetup()
    }
    
    func initialSetup() {
        
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        CommonFunctions.labelSetup(label: headerInfoLabel, text: "", textColor: AppColors.appBlack, font: AppFonts.semibold.withSize(15))
        
    }
}
