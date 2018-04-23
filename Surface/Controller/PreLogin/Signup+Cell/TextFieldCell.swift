//
//  TextFieldCell.swift
//  Surface
//
//  Created by Nandini on 07/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var textFIeld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        textFIeld.autocorrectionType = .no
        textFIeld.cornerRadius(radius: textFIeld.h/2)
        textFIeld.add_LeftPadding(paddingSize: 20.0)
        textFIeld.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Phone_Num.localized, attributes: [NSAttributedStringKey.font:AppFonts.regular.withSize(11.5) , NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)])
        textFIeld.layer.borderWidth = 0.5
        textFIeld.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func load_textField(index:Int , dict:[String:Any] , errMsg: [String]){
        switch index {
        case 2:
            self.setup(placeholder: ConstantString.k_Email.localized, text: dict[ConstantString.k_Email.localized] as? String ?? "" , keypadType: .emailAddress,  errMsg: errMsg[index-1])
        case 3:
            self.setup(placeholder: ConstantString.k_username.localized, text: dict[ConstantString.k_username.localized] as? String ?? "", errMsg: errMsg[index-1])
        default:
            self.setup(placeholder: ConstantString.k_password.localized, text: dict[ConstantString.k_password.localized] as? String ?? "" , isSecure: true)
        }
    }
    
    private func setup(placeholder:String, text:String , keypadType:UIKeyboardType = .default  , isSecure:Bool = false , errMsg:String = ""){
        textFIeld.keyboardType = keypadType
        textFIeld.isSecureTextEntry = isSecure
         self.textFIeld.text = text
         self.textFIeld.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.font:AppFonts.regular.withSize(11.5) , NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)])
        errorLabelHeight.constant = errMsg.isEmpty ? 0 : 21
        errorMessageLabel.isHidden = errMsg.isEmpty
        errorMessageLabel.text = errMsg
        textFIeld.layer.borderColor = text.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
        textFIeld.backgroundColor = text.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    }
}
