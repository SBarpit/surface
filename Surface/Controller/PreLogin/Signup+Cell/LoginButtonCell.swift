//
//  LoginButtonCell.swift
//  Surface
//
//  Created by Nandini on 07/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class LoginButtonCell: UITableViewCell {
    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var alreadyHaveAnAccountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        loginButton.cornerRadius(radius: loginButton.h/2)
    }
}
