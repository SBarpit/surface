//
//  FeedCell.swift
//  Surface
//
//  Created by Nandini Yadav on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var feedSubview: UIView!
    @IBOutlet weak var feedSubviewLeading: NSLayoutConstraint!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var feedSubviewTrailing: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var overLayView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sideOptionButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var commentCounButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var videoBtn: UIImageView!
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        overLayView.radial_GradientColor()
        feedSubview.cornerRadius(radius: 5.0)
        profileImage.cornerRadius(radius: profileImage.h/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoBtn.isHidden = true
        coverImage.image = nil
        profileImage.image = nil
    }
    
    func load_feedCell(index:Int , data:[Featured_List]){
        feedSubviewTrailing.constant = index%2 == 0 ? 0 : 5
        feedSubviewLeading.constant = index%2 == 0 ? 5 : 0
        timeLabel.text = data[index].privous_TimeOfPost
        usernameLabel.text = data[index].user_name
        addressLabel.text = data[index].user_name
        commentCounButton.setTitle("\(data[index].comments_count)", for: .normal)
        viewCountButton.setTitle("\(data[index].views_count)", for: .normal)
     
        if data[index].media_arr.first?.media_type == "2"{
            self.videoBtn.isHidden = false
            if let thumbnail = data[index].media_arr.first?.media_thumbnail{
                let imageUrl = URL(string: thumbnail)
                coverImage.kf.setImage(with: imageUrl, placeholder: nil)
                profileImage.kf.setImage(with: imageUrl, placeholder: nil)
            }
        }else{
        if let thumbnail = data[index].media_arr.first?.media_url{
            self.videoBtn.isHidden = true
            let imageUrl = URL(string: thumbnail)
            coverImage.kf.setImage(with: imageUrl, placeholder: nil)
            profileImage.kf.setImage(with: imageUrl, placeholder: nil)
        }
        }
        self.layoutIfNeeded()
    }
}
