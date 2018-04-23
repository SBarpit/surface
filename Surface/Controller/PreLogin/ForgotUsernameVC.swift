//
//  ForgotUsernameVC.swift
//  Surface
//
//  Created by Nandini Yadav on 08/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ForgotUsernameVC: BaseSurfaceVC {

    //MARK:- Properties
    
    //MARK:- @IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.cornerRadius(radius: textField.h/2)
        textField.add_LeftPadding(paddingSize: 20)
        submitButton.cornerRadius(radius: submitButton.h/2)
         submitButton.layer.borderColor = Global.getGradientImage_Color(size: submitButton.size)?.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    private func initialSetup(){
        
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Email.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        textField.delegate = self
        
        // set gradient color on login border
        submitButton.backgroundColor = .white
        submitButton.layer.borderWidth = 1.0
       
        
        let textSize = Global.textSizeCount(submitButton.currentTitle, font: (submitButton.titleLabel?.font)!, bundingSize: CGSize(width: 80, height: 1000))
        
        submitButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
    }
    
    // validate All FIelds
    private func validateAllField()-> Bool{
        if DidValidate.isBlank(txt:self.textField.text){
            Global.showToast(msg: ConstantString.k_Empty_email.localized)
            return false
        }
        if let email = self.textField.text ,  !email.isEmpty && !DidValidate.isValidEmail(email: email){
            Global.showToast(msg: ConstantString.k_Valid_email_war.localized)
            return false
        }
         return true
    }
    
    //MARK:- @IBActions & Methods
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateAllField(){
            Global.print_Debug("validate fields")
            forgot_Username()
        }
    }
    
    @IBAction func textField_DidChangeEditing(_ sender: UITextField) {
        guard let txt = sender.text else {
            Global.print_Debug("text is empty")
            return
        }
        textField.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        textField.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension ForgotUsernameVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji{
            return false
        }
        
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        
        return newString.length <= 60
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
}

//MARK:- Webservices
extension ForgotUsernameVC{
    
    func forgot_Username(){
        let params : JSONDictionary = ["email": textField.text ?? ""]
        WebServices.forgotUserName(params: params, success: { [weak self] (result) in
            guard let result = result else {return }
            Global.print_Debug(result)
            self?.show_Mail_Success_Alert()
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    func show_Mail_Success_Alert(){
        self.alert_With_Ok_Action(msg: ConstantString.k_username_sent_suceess_msg.localized, done: ConstantString.k_OK.localized) { (success) in
            if success{
                 _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

