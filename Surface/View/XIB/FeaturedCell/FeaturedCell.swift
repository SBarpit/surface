//
//  FeaturedCell.swift
//  Surface
//
//  Created by Nandini Yadav on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
class FeaturedCell: UICollectionViewCell {

    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        userImage.cornerRadius(radius: 2.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       // userImage.imag
    }
    
    func load_featuredCell(index:Int , data:[Featured_List] ){
        nameLabel.text = data[index].user_name
        if let thumbnail = data[index].media_arr.first?.media_thumbnail{
            let imageUrl = URL(string: thumbnail)
            userImage.kf.setImage(with: imageUrl, placeholder: nil)
        }
    }
}
