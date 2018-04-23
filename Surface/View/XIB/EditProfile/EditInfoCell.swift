//
//  EditInfoCell.swift
//  Surface
//
//  Created by Arvind Rawat on 03/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class EditInfoCell: UITableViewCell {
    
    //MARK:- IBOUTLET
    //===============
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //MARK:- AWAKEFORMNIB
    //===================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        
    }
    
    //MARK:- FUNCTIONS
    //================
    func initialSetup() {
        self.sepratorView.backgroundColor = AppColors.separatorLineGray
        
        CommonFunctions.labelSetup(label: titleLabel, text: "", textColor: AppColors.appBlack, font: AppFonts.semibold.withSize(13.5))
        
    }
    
    func populateData(index:Int,data:String) {
       
        sepratorView.isHidden = false
        
        switch index {
        case 0:
            titleLabel.text = "Basic Details"
            sepratorView.isHidden = true
        case 6:
            titleLabel.text = "Locations"
        case 8:
            titleLabel.text = "Links"
        case 10:
            titleLabel.text = "Contact Information"
        default:
            return
        }
    }
}
