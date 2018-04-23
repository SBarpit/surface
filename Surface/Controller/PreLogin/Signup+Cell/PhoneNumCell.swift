//
//  PhoneNumCell.swift
//  Surface
//
//  Created by Nandini on 07/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//


import UIKit

class PhoneNumCell: UITableViewCell {
    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var phoneNumSubView: UIView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var errLabelHeight: NSLayoutConstraint!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.keyboardType = .numberPad
        phoneNumSubView.layer.borderWidth = 0.5
        phoneNumSubView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.backgroundColor = .clear
        countryCodeButton.backgroundColor = .clear
        self.phoneNumSubView.cornerRadius(radius: self.phoneNumSubView.h/2)
        self.textField.add_LeftPadding(paddingSize: 10.0)
        self.textField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Phone_Num.localized, attributes: [NSAttributedStringKey.font:AppFonts.regular.withSize(11.5) , NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)])
    }
    
    func load_PhoneNuberCell(dict:[String:Any] , errMsgs:[String]){
        textField.text = dict[ConstantString.k_Phone_Num.localized] as? String ?? ""
        errLabelHeight.constant = errMsgs[0].isEmpty ? 0 : 21
        errLabel.isHidden = errMsgs[0].isEmpty
        errLabel.text = errMsgs[0]
        if let code = dict[ConstantString.K_Country_code.localized] as? String {
             countryCodeButton.setTitle(code, for: .normal)
             countryCodeButton.setTitleColor(#colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1), for: .normal)
             countryCodeButton.titleLabel?.font = AppFonts.medium.withSize(13.5)
        }else{
            countryCodeButton.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6901960784, blue: 0.6901960784, alpha: 1), for: .normal)
            countryCodeButton.titleLabel?.font = AppFonts.regular.withSize(11.5)
            countryCodeButton.setTitle("+91", for: .normal)
        }
    }
}
