//
//  GenderCell.swift
//  Surface
//
//  Created by Arvind Rawat on 03/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {


    //mark
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
         initialSetup()
    }
    
    func initialSetup() {
    
        CommonFunctions.btnSetup(btn: maleBtn, text: "Male", bgColor: UIColor.clear, titleColor: AppColors.appBlack, font: AppFonts.medium.withSize(14))
         CommonFunctions.btnSetup(btn: femaleBtn, text: "Female", bgColor: UIColor.clear, titleColor: AppColors.appBlack, font: AppFonts.medium.withSize(14))

    }
}
