//
//  ResetPasswordVC.swift
//  Surface
//
//  Created by Nandini Yadav on 08/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseSurfaceVC {

    //MARK:- Properties
    var resetPwd_token:String?
    var reset_PwdType:Int = 0 // 0 for email or 1 for phone number
    var mobileNum:String?
    
    //MARK:- @IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desclabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpTextFieldBottom: NSLayoutConstraint!
    
    @IBOutlet weak var otptextFieldHeight: NSLayoutConstraint!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newPasswordTextField.cornerRadius(radius: newPasswordTextField.h/2)
        newPasswordTextField.add_LeftPadding(paddingSize: 20)
        
        confirmPasswordTextField.cornerRadius(radius: confirmPasswordTextField.h/2)
        confirmPasswordTextField.add_LeftPadding(paddingSize: 20)
        
        otpTextField.cornerRadius(radius: confirmPasswordTextField.h/2)
        otpTextField.add_LeftPadding(paddingSize: 20)
        
        resetButton.layer.borderColor = Global.getGradientImage_Color(size: resetButton.size)?.cgColor
        resetButton.cornerRadius(radius: resetButton.h/2)
        
        if reset_PwdType == 0{
            otpTextFieldBottom.constant = 0
            otptextFieldHeight.constant = -(Global.screenHeight * (45/667))
            otpTextField.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = resetPwd_token{
            Global.print_Debug(token)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetPwd_token = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    private func initialSetup(){
        newPasswordTextField.layer.borderWidth = 0.5
        newPasswordTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: ConstantString.K_New_Pwd.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        newPasswordTextField.delegate = self
        newPasswordTextField.addTarget(self, action: #selector(textField_EditingDidChanged(_:)), for: .editingChanged)
        
        confirmPasswordTextField.layer.borderWidth = 0.5
        confirmPasswordTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: ConstantString.K_Confirm_Pwd.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.addTarget(self, action: #selector(textField_EditingDidChanged(_:)), for: .editingChanged)
        
        otpTextField.layer.borderWidth = 0.5
        otpTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        otpTextField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        otpTextField.delegate = self
        otpTextField.addTarget(self, action: #selector(textField_EditingDidChanged(_:)), for: .editingChanged)
        otpTextField.text = ""
        
        // set gradient color on login border
        resetButton.backgroundColor = .white
        resetButton.layer.borderWidth = 1.0
      
        let textSize = Global.textSizeCount(resetButton.currentTitle, font: (resetButton.titleLabel?.font)!, bundingSize: CGSize(width: 70, height: 1000))
        resetButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
    }
    
    // validate All FIelds
    private func validateAllField()-> Bool{
        
        if let txt =  otpTextField.text , (txt.length < 4)  && (reset_PwdType == 1){
            Global.showToast(msg: ConstantString.k_valid_pin.localized)
        }
        if DidValidate.isBlank(txt: newPasswordTextField.text){
            Global.showToast(msg: ConstantString.K_empty_New_pwd.localized)
            return false
        }
        if DidValidate.isInvalidPwd(txt: newPasswordTextField.text){
            Global.showToast(msg: ConstantString.k_Pwd_length_war.localized)
            return false
        }
        if DidValidate.isBlank(txt: confirmPasswordTextField.text){
            Global.showToast(msg: ConstantString.K_empty_conf_pwd.localized)
            return false
        }
        
        if  let newPwd = newPasswordTextField.text , let confriPwd = confirmPasswordTextField.text , newPwd != confriPwd{
            Global.showToast(msg: ConstantString.K_pwd_mismatch.localized)
            return false
        }
        return true
    }
    
    //MARK:- @IBActions & Methods
    @objc func textField_EditingDidChanged(_ sender: UITextField) {
        guard let txt = sender.text else {
            Global.print_Debug("text is empty")
            return
        }
        if sender === newPasswordTextField{
            newPasswordTextField.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
             newPasswordTextField.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        }else if sender === confirmPasswordTextField{
            confirmPasswordTextField.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
            confirmPasswordTextField.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        }else{
            otpTextField.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
            otpTextField.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
            resetPwd_token = sender.text
        }
        
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        popTo_COntoller()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateAllField(){
            reset_password()
        }
        else{
            Global.print_Debug("not validate field")
            return
        }
    }
}

extension ResetPasswordVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === otpTextField{
           textField.keyboardType = .numberPad
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === otpTextField{
           newPasswordTextField.becomeFirstResponder()
        }
        else if textField === newPasswordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
            if validateAllField(){
                Global.print_Debug("validate fields")
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji{
            return false
        }
        
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        if textField === otpTextField{
           return newString.length <= 4
        }
        return newString.length <= 15
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
}

//MARK:-
extension ResetPasswordVC{
    
    func reset_password(){
        var params :JSONDictionary = ["token":resetPwd_token ?? "" , "password": newPasswordTextField.text ?? ""]
        if reset_PwdType == 1{
            params["send_to"] = "1"
            params["mobile"]  = mobileNum ?? ""
        }
        
        WebServices.resetPassword(params: params, success: { [weak self] (result) in
            guard let result = result else { return }
            Global.showToast(msg: result["msg"].stringValue)
            self?.popTo_COntoller()
        }) { (err, code) in
            Global.print_Debug(err)
        }
    }
    
    func popTo_COntoller(){
        let viewController :[UIViewController] = (self.navigationController?.viewControllers)!
        for loginScene in viewController{
            if(loginScene is LoginVC){
                self.navigationController!.popToViewController(loginScene, animated: true);
            }
        }
    }
}
