//
//  EditProfileButton.swift
//  Surface
//
//  Created by Arvind Rawat on 02/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class EditProfileButton: UITableViewCell {

    
    //MARK: IBOUTLET
    //==============
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initialSetup(){
      separatorView.backgroundColor = AppColors.separatorLineGray
      editProfileBtn.cornerBorder(color: AppColors.separatorLineGray, radius: 5)

        CommonFunctions.btnSetup(btn: editProfileBtn, text: ConstantString.k_EditProfile_Btn.localized, bgColor: UIColor.clear, titleColor:AppColors.appBlack , font: AppFonts.medium.withSize(11.5))
        
    }
}
