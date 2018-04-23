//
//  ChangeEmailVC.swift
//  Surface
//
//  Created by Arvind Rawat on 04/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ChangeEmailVC: UIViewController {
    
    
    //MARK:- IBOUTLETS
    //=================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendVerificationBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
   
    
    //MARK:- viewDidLoad
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()

       initialSetup()
    }
    
    
    func initialSetup() {
        
        sendVerificationBtn.layer.borderColor = Global.getGradientImage_Color(size: sendVerificationBtn.size)?.cgColor
        sendVerificationBtn.cornerRadius(radius: sendVerificationBtn.h/2)
        // set gradient color on login border
        sendVerificationBtn.backgroundColor = .white
        sendVerificationBtn.layer.borderWidth = 1.0
        
        let textSize = Global.textSizeCount(sendVerificationBtn.currentTitle, font: (sendVerificationBtn.titleLabel?.font)!, bundingSize: CGSize(width: 60, height: 1000))
        sendVerificationBtn.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
        
        outerView.cornerRadius(radius: emailTextField.h/2)
        emailTextField.add_LeftPadding(paddingSize: 20)
        outerView.layer.borderWidth = 0.5
        outerView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        outerView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Email.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        emailTextField.delegate = self
        
    }
    
    
    //MARK:- IBACTIONS
    //================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendVerificationBtnAction(_ sender: UIButton) {
        
        
        
        
    }
}


//MARK:- EXTENSION UITEXTFIELDDELEGATE
//====================================
extension ChangeEmailVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        if string.containsEmoji{
            return false
        }
        
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        return newString.length <= 64
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeEmailExist()
        textField.layoutIfNeeded()
    }
}


//MARK:- EXTENSION UITEXTFIELDDELEGATE
//====================================
extension ChangeEmailVC{
    
    
    func changeEmailExist(){
        
        var param = JSONDictionary()
        param["email"] = emailTextField.text
       
        WebServices.check_username(params: param, success: { (results) in
           
            if let result = results?.dictionaryValue{
               
                if let status = result["status"]?.boolValue{
                    
                    
                    if !status{
                        if let message = result["msg"]?.stringValue{
                            Global.showToast(msg: message)
                        }
                    }
                }
            }
        }) { (error, code) in
            
            Global.showToast(msg: error.localized)
        }
    }

    func changeEmail(){
        
        var param = JSONDictionary()
        param["email"] = emailTextField.text
        WebServices.change_EmailPhone(params: param, success: { (result) in
            
        
            
        }) { (error, code) in
            
            Global.showToast(msg: error.localized)
        }
    }
    
}
