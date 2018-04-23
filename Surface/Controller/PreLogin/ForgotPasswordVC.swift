//
//  ForgotPasswordVC.swift
//  Surface
//
//  Created by Nandini Yadav on 08/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseSurfaceVC {

    //MARK:- Properties
    private var countryCode:String?
    
    //MARK:- @IBOutlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var codeSubViewWidth: NSLayoutConstraint!
    @IBOutlet weak var codeSubView: UIView!
    @IBOutlet weak var textFieldSubView: UIView!
    @IBOutlet weak var EmailSegementControl: UISegmentedControl!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var codeButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorViewWidth: NSLayoutConstraint!
    @IBOutlet weak var seperatorViewLeading: NSLayoutConstraint!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldSubView.cornerRadius(radius: textFieldSubView.h/2)
        submitButton.cornerRadius(radius: submitButton.h/2)
        EmailSegementControl.layer.cornerRadius = EmailSegementControl.h/2
        EmailSegementControl.layer.borderWidth = 1.0
        EmailSegementControl.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        EmailSegementControl.layer.masksToBounds = true
        EmailSegementControl.clipsToBounds = true
        
       // set corner radius of segment subviews
        EmailSegementControl.subviews[0].cornerRadius(radius: EmailSegementControl.subviews[0].h/2)
        EmailSegementControl.subviews[1].cornerRadius(radius: EmailSegementControl.subviews[1].h/2)
        
        submitButton.layer.borderColor = Global.getGradientImage_Color(size: submitButton.size)?.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    
    //MARK:- setup methods
    private func initialSetup(){
        EmailSegementControl.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        textFieldSubView.layer.borderWidth = 0.5
        textFieldSubView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.delegate = self
        
        // set gradient color on login border
        submitButton.backgroundColor = .white
        submitButton.layer.borderWidth = 1.0
        let textSize = Global.textSizeCount(submitButton.currentTitle, font: (submitButton.titleLabel?.font)!, bundingSize: CGSize(width: 70, height: 1000))
        submitButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
        
        // segment controller
        EmailSegementControl.setTitleTextAttributes([NSAttributedStringKey.font: AppFonts.medium.withSize(13.5) , NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.6901960784, green: 0.6862745098, blue: 0.6862745098, alpha: 1) ], for: .normal)
        EmailSegementControl.setTitleTextAttributes([NSAttributedStringKey.font: AppFonts.medium.withSize(13.5) , NSAttributedStringKey.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ], for: .selected)
        setupTextField()
        setup_forCountryButton()
    }
    
    private func setupTextField(){
        if EmailSegementControl.selectedSegmentIndex == 0{
            codeSubViewWidth.constant = 0
            codeButtonLeading.constant = 0
            seperatorViewLeading.constant = 0
            seperatorViewWidth.constant = 0
            codeSubView.isHidden = true
            textField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Email.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
            textField.add_LeftPadding(paddingSize: 10.0)
            textField.keyboardType = .emailAddress
            textField.text = ""
        }else{
            codeSubViewWidth.constant = 75
            codeButtonLeading.constant = 10
            seperatorViewLeading.constant = 5
            seperatorViewWidth.constant = 0.5
            codeSubView.isHidden = false
            textField.add_LeftPadding(paddingSize: 0)
            textField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Phone_Num.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
            textField.keyboardType = .numberPad
            textField.text = ""
        }
        self.view.layoutIfNeeded()
    }
    
    private func setup_forCountryButton(){
        if let code = countryCode {
            countryCodeButton.setTitle(code, for: .normal)
            countryCodeButton.setTitleColor(#colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1), for: .normal)
            countryCodeButton.titleLabel?.font = AppFonts.medium.withSize(13.5)
        }else{
            countryCodeButton.setTitleColor(#colorLiteral(red: 0.6941176471, green: 0.6901960784, blue: 0.6901960784, alpha: 1), for: .normal)
            countryCodeButton.titleLabel?.font = AppFonts.regular.withSize(11.5)
            countryCodeButton.setTitle("+91", for: .normal)
        }
    }
    
    //MARK:- ==========
    //MARK:- validate All FIelds
    private func validateAllField()-> Bool{
        if EmailSegementControl.selectedSegmentIndex == 0{
            if DidValidate.isBlank(txt:self.textField.text){
                Global.showToast(msg: ConstantString.k_Empty_email.localized)
                return false
            }
            if let email = self.textField.text ,  !email.isEmpty && !DidValidate.isValidEmail(email: email){
                Global.showToast(msg: ConstantString.k_Valid_email_war.localized)
                return false
            }
             return true
        }else{
            if DidValidate.isBlank(txt:countryCode){
                Global.showToast(msg: ConstantString.k_empty_country_Code.localized)
                return false
            }
            if DidValidate.isBlank(txt: textField.text){
                Global.showToast(msg: ConstantString.k_Empty_phone_war.localized)
                return false
            }
            if DidValidate.isInValidPhoneNum(txt: textField.text){
                Global.showToast(msg: ConstantString.k_Mob_no_8_digit.localized)
                return false
            }
             return true
        }
    }
    
    //MARK:- @IBActions & Methods
    @IBAction func countyrCodeButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .PreLogin)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }
    
    @IBAction func textField_EditingDidChanged(_ sender: UITextField) {
        guard let txt = sender.text else {
            Global.print_Debug("text is empty")
            return
        }
        textFieldSubView.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
        textFieldSubView.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateAllField(){
            Global.print_Debug("validate")
            send_Otp_Code()
        }
        else{
            Global.print_Debug("not validate field")
            return
        }
    }
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        setupTextField()
    }
}

//MARK:- UItextField Delegate
extension ForgotPasswordVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji{
            return false
        }
        let length = EmailSegementControl.selectedSegmentIndex == 0 ? 60 : 15
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        
        return newString.length <= length
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
}

//MARK:- SetContryCode Delegate
//=============================
extension ForgotPasswordVC : SetContryCodeDelegate {
    func setCountryCode(country_info: JSONDictionary) {
        countryCode = "+\(country_info["CountryCode"]!)"
        countryCodeButton.setTitle(countryCode, for: .normal)
        setup_forCountryButton()
    }
}

//MARK:- Webservices
extension ForgotPasswordVC{
    
    func send_Otp_Code(){
        var params = JSONDictionary()
        if EmailSegementControl.selectedSegmentIndex == 0{
            params["email"] = textField.text ?? ""
        }else{
            params["mobile"] = textField.text ?? ""
        }
        
        WebServices.forgotPassword(params: params, success: { [weak self] (result) in
            guard self != nil else {return}
            guard let result = result else {return }
            Global.print_Debug(result)
            self?.show_Mail_Success_Alert(type: self?.EmailSegementControl.selectedSegmentIndex ?? 0)
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    func show_Mail_Success_Alert(type: Int){
        let msg = type == 0  ? ConstantString.k_resetPwd_link_Success_msg.localized : ConstantString.k_Otp_sent_on_mobile_success_msg.localized
        self.alert_With_Ok_Action(msg: msg, done: ConstantString.k_OK.localized) { (success) in
            if success{
                if type == 1{
                    let resetPwdScene = ResetPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
                    resetPwdScene.reset_PwdType = self.EmailSegementControl.selectedSegmentIndex
                    resetPwdScene.mobileNum = self.textField.text
                    self.navigationController?.pushViewController(resetPwdScene, animated: true)
                }else{
                     _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
