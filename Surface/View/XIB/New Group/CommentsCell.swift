//
//  CommentsCell.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 05/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
            self.profileImageView?.layer.cornerRadius = (self.profileImageView?.bounds.width)!/2
            self.profileImageView.clipsToBounds = true
        }
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func replyAction(_ sender: UIButton) {
    }
    
}
