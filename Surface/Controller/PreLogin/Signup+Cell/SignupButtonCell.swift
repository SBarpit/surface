//
//  SignupButtonCell.swift
//  Surface
//
//  Created by Nandini on 07/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class SignupButtonCell: UITableViewCell {
    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set gradient color on border
        signUpButton.backgroundColor = .white
        signUpButton.layer.borderWidth = 1.0
        signUpButton.cornerRadius(radius: signUpButton.h/2)
        let textSize = Global.textSizeCount(signUpButton.currentTitle, font: (signUpButton.titleLabel?.font)!, bundingSize: CGSize(width: 70, height: 1000))
        
        signUpButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        signUpButton.layer.borderColor = Global.getGradientImage_Color(size: signUpButton.size)?.cgColor
    }
}
