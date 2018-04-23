//
//  FriendRequestCell.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 04/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLAbel: UILabel!
    @IBOutlet weak var newRequestLabel: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setUpView(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2
        self.profileImageView.clipsToBounds = true
        self.acceptButton.layer.cornerRadius = 5
        self.rejectButton.layer.cornerRadius = 5
        self.acceptButton.layer.borderWidth = 0.3
        self.rejectButton.layer.borderWidth = 0.3
        self.rejectButton.layer.borderColor = UIColor(red: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0).cgColor
        self.acceptButton.backgroundColor = UIColor(red: 94/255.0, green: 152/255.0, blue: 225/255.0, alpha: 1.0)
        self.userNameLAbel.font = AppFonts.semibold.withSize(13.5)
        self.acceptButton.titleLabel?.font = AppFonts.regular.withSize(11.5)
        self.rejectButton.titleLabel?.font = AppFonts.regular.withSize(11.5)
        self.nameLabel.font = AppFonts.medium.withSize(13.5)
        self.newRequestLabel.font = AppFonts.semibold.withSize(11.5)
    }

}
