//
//  FriendsTableViewCell.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 04/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
  
    
    //MARK:- IBOUTETS
    //===============
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var userImageView: UIImageView!


    //MARK:- AWAKEFROMNIB
    //===================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    
    //MARK:- INITIALSETUP
    //==================
    func initialSetup(){
      
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2
        self.profileImageView.clipsToBounds = true
        self.usernameLB.font = AppFonts.medium.withSize(13.5)
        self.descLable.font = AppFonts.regular.withSize(13.5)
        self.timeLB.font = AppFonts.light.withSize(11.5)
        
    }
}
