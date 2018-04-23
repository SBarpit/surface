//
//  MainCell.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 02/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    
    //MARK:- IBOUTLETS
    //================
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
    
    //MARK:- FUNCTIONS
    //================
    func initialSetup() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2
        self.profileImageView.clipsToBounds = true
    }
}
