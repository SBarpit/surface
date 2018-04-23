//
//  ProfileHeader.swift
//  Surface
//
//  Created by Arvind Rawat on 31/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewHeaderFooterView {
    
    
    //MARK:- IBOUTLET
    //===============
    @IBOutlet weak var profileImage     : UIImageView!
    @IBOutlet weak var userName         : UILabel!
    @IBOutlet weak var addressLabel     : UILabel!
    @IBOutlet weak var addFriendBtn     : UIButton!
    @IBOutlet weak var messageBtn       : UIButton!
    @IBOutlet weak var postBtn          : UIButton!
    @IBOutlet weak var friendCountBtn   : UIButton!
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.messageBtn.addBorder(withColor: AppColors.appTextGray, andWidth: 0.5)
        
        
    }
    override func awakeFromNib() {
        initialSetup()
    }
    
    //MARK:- Private function
    //=======================
    
    private func initialSetup() {
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      
        setupCornerRadius()
        self.addFriendBtn.isHidden = true
        self.messageBtn.isHidden = true
        messageBtn.cornerBorder(color: AppColors.separatorLineGray, radius: 5)
    
        postBtn.cornerBorder(color: AppColors.separatorLineGray, radius: 7)
        friendCountBtn.cornerBorder(color: AppColors.separatorLineGray, radius: 7)
        
        CommonFunctions.labelSetup(label: userName, text: "ALICE JHONSON, 25", textColor: AppColors.appBlack, font: AppFonts.semibold.withSize(20))
        
        CommonFunctions.labelSetup(label: addressLabel, text: "New York,Bell-25", textColor: AppColors.appBlack, font: AppFonts.medium.withSize(12.0))
        
        CommonFunctions.btnSetup(btn: addFriendBtn, text: "Add Friend", bgColor: AppColors.profileBtnColor, titleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), font: AppFonts.regular.withSize(15))
        CommonFunctions.btnSetup(btn: messageBtn, text: "Message", bgColor: AppColors.appTextGray, titleColor: AppColors.appBlack, font: AppFonts.regular.withSize(15))
        
        
    }
    func setupCornerRadius() {
        postBtn.cornerRadius(radius: 0.6)
        friendCountBtn.cornerRadius(radius: 0.6)
        messageBtn.cornerRadius(radius: 0.5)
        addFriendBtn.cornerRadius(radius: 0.5)
    }
    
    func populateHeader(data:UserInfoModel?) {

        if let profileImage = data?.profile_image{
            if let url = URL(string: profileImage) {
                self.profileImage.kf.setImage(with: url, placeholder: nil)
            }
        }
       
        if let name = data?.user_name{
            userName.text = name
        }
        
        if let count = data?.friends{
            friendCountBtn.setTitle("Friends \n\(count)", for: .normal)
        }
        if let post = data?.posts_count{
            friendCountBtn.setTitle("post \n\(post)", for: .normal)
        }
        
    }
}
