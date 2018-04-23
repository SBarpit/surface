//
//  EditProfileTextFieldCell.swift
//  Surface
//
//  Created by Arvind Rawat on 03/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditProfileTextFieldCell: UITableViewCell {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var infoTextField: SkyFloatingLabelTextField!
    
    //MARK:- AWAKEFROMNIB
    //===================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        infoTextField.rightView = nil
        
    }
    
    //MARK:- FUNCTIONS
    //================
    
    func initialSetup() {
        self.infoTextField.isUserInteractionEnabled = true
        self.infoTextField.font = AppFonts.regular.withSize(14.5)
        CommonFunctions.textFieldSetup(textField: infoTextField, placeholder: "", textColor: AppColors.appTextGray, font: AppFonts.regular.withSize(13.5))
        infoTextField.lineHeight = 1.0
        infoTextField.selectedLineHeight = 1.3
        
    }
    
    func populateData(index:IndexPath,data:String,placeHolder:String) {
        
        
        self.infoTextField.placeholder = placeHolder
        switch index.section {
        case 0:
            return
        case 1:
            
            self.infoTextField.text = data
        case 2:
            addRightBtn(textField: infoTextField)
            self.infoTextField.text = data
        case 3:
            self.infoTextField.text = data
        case 4:
            //rightViewButton(infoTextField)
            addRightBtn(textField: infoTextField)
           // self.infoTextField.isUserInteractionEnabled = false
            self.infoTextField.text = data
        default:
            return
        }
    }
    
    func addRightBtn(textField:UITextField) {
        let rightView = UIButton()
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        rightView.frame = frame
        rightView.layer.borderColor = Global.getGradientImage_Color(size: rightView.size)?.cgColor
     
            
            let textSize = Global.textSizeCount("Change", font:AppFonts.bold.withSize(8), bundingSize: CGSize(width: 40, height: 1000))
            rightView.setTitle("Change", for: .normal)
        
        rightView.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
      //rightView.backgroundColor = UIColor.red
        rightView.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        textField.rightView = rightView
        textField.rightViewMode = UITextFieldViewMode.always
        textField.layoutIfNeeded()
        
        
    }
    
    @objc func btnTapped(sender:UIButton){
        
        self.infoTextField.becomeFirstResponder()
        
    }
}
