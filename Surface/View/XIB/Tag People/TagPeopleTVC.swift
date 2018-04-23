//
//  TagPeopleTVC.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class TagPeopleTVC: UITableViewCell {

    
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        
    }
    
    func setUpView(){
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2
        self.profileImageView.clipsToBounds = true
        self.backgroundColor = .white
        self.userNameLabel.font = AppFonts.semibold.withSize(13.5)
        self.nameLabel.font = AppFonts.medium.withSize(11.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
