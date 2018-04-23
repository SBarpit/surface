//
//  ProfileInfoCell.swift
//  Surface
//
//  Created by Arvind Rawat on 31/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    //MARK:- IBOUTLETS
    //================
    
    @IBOutlet weak var separatorView      : UIView!
    @IBOutlet weak var birthdayImageView  : UIImageView!
    @IBOutlet weak var birthdayLabel      : UILabel!
    @IBOutlet weak var workImageView      : UIImageView!
    @IBOutlet weak var workLabel          : UILabel!
    @IBOutlet weak var descreptionLabel   : UILabel!
    
    
    //MARK:- AWAKEFROMNIB
    //===================
    override func awakeFromNib() {
        super.awakeFromNib()
       
        initialSetup()
    
    }
    
    //MARK:- FUNCTIONS
    //================
    func initialSetup() {
        self.separatorView.backgroundColor = AppColors.separatorLineGray
        self.birthdayImageView.image = #imageLiteral(resourceName: "icUserBday")
        self.workImageView.image = #imageLiteral(resourceName: "icUserWork")
        CommonFunctions.labelSetup(label: birthdayLabel, text: "", textColor: AppColors.appBlack, font: AppFonts.medium.withSize(13.5))
      
        CommonFunctions.labelSetup(label: workLabel, text: "", textColor: AppColors.appBlack, font: AppFonts.medium.withSize(13.5))
      
        CommonFunctions.labelSetup(label: descreptionLabel, text: "", textColor: AppColors.appTextGray, font: AppFonts.regular.withSize(13.5))
    }
    
    func populateCell(data:UserInfoModel?,index:Int) {
        
        if let birthday = data?.dob, !birthday.isEmpty{
            self.birthdayLabel.text = birthday
        }else{
            
            self.birthdayLabel.text = "NA"
        }
        if let work = data?.dob,!work.isEmpty{
            self.workLabel.text = "Company Name"
        }else{
            self.workLabel.text = "NA"
        }
        
        if let description = data?.bio , !description.isEmpty{
            self.descreptionLabel.text = description
        }else{
            self.descreptionLabel.text = "Could not successfully update network info during initialization Could not successfully Please set a custom UIView with your desired background color to the backgroundView property instead."
        }
    }
}
