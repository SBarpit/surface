//
//  ReplyCell.swift
//  Surface
//
//  Created by Appinventiv Mac on 06/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
            self.profileImageView.clipsToBounds = true
    }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
