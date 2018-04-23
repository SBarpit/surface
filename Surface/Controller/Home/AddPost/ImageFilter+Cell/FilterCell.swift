//
//  FilterCell.swift
//  Surface
//
//  Created by Nandini Yadav on 19/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {
    
    //MARK:- Properties
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            self.loader.stopAnimating()
            self.loader.isHidden = true
            imageView.image = thumbnailImage
        }
    }
    
    //MARK:- @IBOutlets
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet var title: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var black_IndicatorView: UIView!
    @IBOutlet weak var filterSubView: UIView!
    @IBOutlet weak var filterSubviewTrailling: NSLayoutConstraint!
    @IBOutlet weak var filterSubviewLeading: NSLayoutConstraint!
    
     //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpSubView()
    }
    
    func setUpSubView(){
        imageView.cornerRadius(radius: 15)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
