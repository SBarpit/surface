//
//  HeaderSection.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 02/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class HeaderSection: UITableViewCell {

    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var headingLB: UILabel!
  
    //MARK:- AWAKEFROMNIB
    //===================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        self.backgroundColor = UIColor.white
    }
    
    
    //MARK:- FUNCTIONS
    //================
    func initialSetup() {
        

        
    }
}
