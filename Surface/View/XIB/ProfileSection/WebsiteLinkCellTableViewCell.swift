//
//  WebsiteLinkCellTableViewCell.swift
//  Surface
//
//  Created by Arvind Rawat on 02/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class WebsiteLinkCellTableViewCell: UITableViewCell {

    //MARK: IBOUTLET
    //==============
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    
    //MARK: AWAKEFROMNIB
    //==================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    //MARK: FUNCTION
    //==============
    
    func initialSetup() {
        self.separatorView.backgroundColor = AppColors.separatorLineGray
        self.linkLabel.textColor = UIColor.blue
      
        self.linkImageView.image = #imageLiteral(resourceName: "icUserLinks")
        CommonFunctions.labelSetup(label: linkLabel, text: "Dummy Link", textColor: UIColor.blue, font: AppFonts.medium.withSize(14))
        
    }
    
    func populateData(data:String,index:Int){
        
        
    }
}
