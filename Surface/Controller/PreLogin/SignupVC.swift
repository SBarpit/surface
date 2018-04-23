//
//  SignupVC.swift
//  Surface
//
//  Created by Nandini on 07/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON

class SignupVC: BaseSurfaceVC {
   
    //MARK:- Propertiesderi
    var dict = [String:Any]()
    private var isAcceptTerms:Bool = false
    private var errorMsg_arr:[String] = ["","",""]
    var isSocialType : Bool = false
    var provider:String = ""
    
    //MARK:- @IBOutlets
    @IBOutlet weak var tableView: UITableView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        intitialSetup()
    }
    
    // MARK:- Private Methods
    private func intitialSetup(){
        // register nib class to tableView
        dict[ConstantString.K_Country_code.localized] = "+91"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // validate All FIelds
    private func validateAllField()-> Bool{
       
        if DidValidate.isBlank(txt:dict[ConstantString.K_Country_code.localized] as? String){
            Global.showToast(msg: ConstantString.k_empty_country_Code.localized)
            return false
        }
        if DidValidate.isBlank(txt:dict[ConstantString.k_Phone_Num.localized] as? String){
            Global.showToast(msg: ConstantString.k_Empty_phone_war.localized)
            return false
        }
        if DidValidate.isInValidPhoneNum(txt: dict[ConstantString.k_Phone_Num.localized] as? String){
            Global.showToast(msg: ConstantString.k_Mob_no_8_digit.localized)
            return false
        }
        if DidValidate.isBlank(txt:dict[ConstantString.k_Email.localized] as? String){
            Global.showToast(msg: ConstantString.k_Empty_email.localized)
            return false
        }
        if let email = self.dict[ConstantString.k_Email.localized] as? String ,  !email.isEmpty && !DidValidate.isValidEmail(email: email){
            Global.showToast(msg: ConstantString.k_Valid_email_war.localized)
            return false
        }
        if DidValidate.isBlank(txt: self.dict[ConstantString.k_username.localized] as? String){
            Global.showToast(msg: ConstantString.k_Empty_username_war.localized)
            return false
        }
        if DidValidate.isInvalidUsername(txt: dict[ConstantString.k_username.localized] as? String){
            Global.showToast(msg: ConstantString.k_username_length_war.localized)
            return false
        }
        if !isSocialType && DidValidate.isBlank(txt: dict[ConstantString.k_password.localized] as? String){
            Global.showToast(msg: ConstantString.k_Empty_pwd_war.localized)
            return false
        }
        if !isSocialType && DidValidate.isInvalidPwd(txt: dict[ConstantString.k_password.localized] as? String){
            Global.showToast(msg: ConstantString.k_Pwd_length_war.localized)
            return false
        }
        if !isAcceptTerms{
            Global.showToast(msg: ConstantString.k_accept_terms_condition.localized)
            return false
        }
        
        return true
    }
    
    fileprivate func updateTableView(){
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //MARK:- @IBActions & Methods
    
    @objc func loginInButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
       self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signUpButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let isCheck = errorMsg_arr.filter { (str) -> Bool in
            return !str.isEmpty
        }
        Global.print_Debug("arr:- \(isCheck) lenght:\(isCheck.count)")

        if isCheck.isEmpty && validateAllField() {
            Global.print_Debug("validate")
            if isSocialType{
               social_signup()
            }else{
                userSignup()
            }
        }
    }

    @objc func countryCodeButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .PreLogin)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
    }
    
    @objc func acceptTermsAndConditonButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let index = sender.tableViewIndexPath(tableView: self.tableView) else {return }
        guard let cell = self.tableView.cellForRow(at: index) as? TermsAndConditionsCell else {return }
        cell.checkButton.isSelected = !cell.checkButton.isSelected
        self.isAcceptTerms = cell.checkButton.isSelected
    }
}

// MARK:- UITableView Delegate/ DataSource
extension SignupVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return Global.screenHeight < 667 ? 100 : 200
        case 1, 2, 3:
                return errorMsg_arr[indexPath.row-1].isEmpty ? 60 : 90
        case 4:
            return isSocialType ? 0 : 60
        case 5:
            return 65
        default:
             return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.appLogoCell.cellID) as? AppLogoCell else { fatalError("appLogoCell not found ") }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.phoneNumCell.cellID) as? PhoneNumCell else {
                fatalError("phoneNumCell not found ")
            }
            cell.countryCodeButton.addTarget(self, action: #selector(countryCodeButtonTapped(_:)), for: .touchUpInside)
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: #selector(textDidChangeEditing(_:)), for: .editingChanged)
            cell.load_PhoneNuberCell(dict: dict , errMsgs: errorMsg_arr)
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.termsAndConditionsCell.cellID) as? TermsAndConditionsCell else { fatalError("TermsAndConditionsCell not found ") }
            cell.checkButton.addTarget(self, action: #selector(acceptTermsAndConditonButtonTapped(_:)), for: .touchUpInside)
            cell.termsAndConditionLabel.delegate = self
            self.setUp_termsAndCondition(label: cell.termsAndConditionLabel)
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.signupButtonCell.cellID) as? SignupButtonCell else { fatalError("signupButtonCell not found ") }
            cell.signUpButton.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.loginButtonCell.cellID) as? LoginButtonCell else { fatalError("LoginButtonCell not found ") }
            cell.loginButton.addTarget(self, action: #selector(loginInButtonTapped(_:)), for: .touchUpInside)
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.textFieldCell.cellID) as? TextFieldCell else { fatalError("TextFieldCell not found ") }
            cell.textFIeld.addTarget(self, action: #selector(textDidChangeEditing(_:)), for: .editingChanged)
            cell.textFIeld.delegate = self
            cell.load_textField(index: indexPath.row, dict: self.dict , errMsg: errorMsg_arr)
            return cell
        }
    }
}

// MARK:- UITextField Delegate
extension SignupVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let index = textField.tableViewIndexPath(tableView: self.tableView) else {return }
        if let cell = self.tableView.cellForRow(at: index) as? TextFieldCell , index.row < 4{
            cell.errorMessageLabel.text = ""
            errorMsg_arr[index.row-1] = ""
        }
        else if let cell = self.tableView.cellForRow(at: index) as? PhoneNumCell {
            cell.errLabel.text = ""
            errorMsg_arr[index.row-1] = ""
        }
        self.updateTableView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = textField.tableViewIndexPath(tableView: self.tableView) , !string.containsEmoji else {return false}
        
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        if index.row == 2{
            return newString.length <= 60
        }
        else if index.row == 3{
            return newString.length <= 30
        }else{
           return newString.length <= 15
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text , !text.isEmpty else {return}
        guard let index = textField.tableViewIndexPath(tableView: self.tableView) else {return }
        guard let txt = textField.text , !txt.isEmpty else {
            return
        }
        if index.row ==  1{
            check_usernameAndPhoneNum(["mobile":text], indexpath: index)
        }
        else if index.row == 2{
            if !DidValidate.isValidEmail(email: txt){
                Global.showToast(msg: ConstantString.k_Valid_email_war.localized)
                return
            }else{
                 check_usernameAndPhoneNum(["email":text], indexpath: index)
            }
        } else if index.row ==  3{
            check_usernameAndPhoneNum(["username":text], indexpath: index)
        }
        textField.layoutIfNeeded()
    }
    
    //Did change Editing in text Field
    @objc func textDidChangeEditing(_ sender : UITextField){
        guard let txt = sender.text else {
            Global.print_Debug("text is empty")
            return
        }
        guard let index = sender.tableViewIndexPath(tableView: self.tableView) else {return }
        if let cell = self.tableView.cellForRow(at: index) as? TextFieldCell {
            cell.textFIeld.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
            cell.textFIeld.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
            if index.row != 3 && txt.isEmpty{
                cell.textFIeld.addRightIcon(nil , imageSize: CGSize.zero)
            }
        }
        
        else if let cell = self.tableView.cellForRow(at: index) as? PhoneNumCell {
            cell.phoneNumSubView.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
            cell.phoneNumSubView.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
            if txt.isEmpty{
                cell.textField.addRightIcon(nil , imageSize: CGSize.zero)
            }
        }
        
        switch index.row{
        case 1:
            dict[ConstantString.k_Phone_Num.localized] = sender.text
        case 2:
            dict[ConstantString.k_Email.localized] = sender.text
        case 3:
            dict[ConstantString.k_username.localized] = sender.text
        default:
            dict[ConstantString.k_password.localized] = sender.text
        }
    }
}

//MARK:- TTTAttributedLabel Delegate
extension SignupVC: TTTAttributedLabelDelegate{
 
    func setUp_termsAndCondition(label:TTTAttributedLabel){
        let link_str: NSString = label.text! as NSString
        
        let web_link_AttributedString = NSAttributedString(string:link_str as String, attributes: [NSAttributedStringKey.font: label.font, NSAttributedStringKey.paragraphStyle: NSMutableParagraphStyle(), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)])
        
        label.setText(web_link_AttributedString)
        label.linkAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)]
       
        let terms_range : NSRange = link_str.range(of: ConstantString.k_termsAndCondi.localized)
        label.addLink(to: URL(string: ""), with: terms_range)
    
        let privacy_range: NSRange = link_str.range(of: ConstantString.k_privacy_Policy.localized)
        label.addLink(to: URL(string: ""), with: privacy_range)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url != nil{
            Global.print_Debug("selected url :- \(url)")
            let safariVC  = SFSafariViewController(url:url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}


//MARK:- SetContryCode Delegate
//=============================
extension SignupVC : SetContryCodeDelegate {
    
    func setCountryCode(country_info: JSONDictionary) {
        dict[ConstantString.K_Country_code.localized] = "+\(country_info["CountryCode"]!)"
        self.tableView.reloadData()
    }
}

//MARK:- Webservices
extension SignupVC{
    
    func check_usernameAndPhoneNum(_ params :JSONDictionary , indexpath : IndexPath){
        WebServices.check_username(params: params, success: {  [weak self] (result) in
            guard let result = result else {return }
            
            self?.error_Messages_forUniqueCheck(indexpath: indexpath, isExists: result["status"].boolValue)
      
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }

    func userSignup(){
        let params:JSONDictionary = ["email":dict[ConstantString.k_Email.localized] as? String ?? "" ,
                                     "username":dict[ConstantString.k_username.localized] as? String ?? "" ,
                                     "password":dict[ConstantString.k_password.localized] as? String ?? "" ,
                                     "country_code":dict[ConstantString.K_Country_code.localized] as? String ?? "",
                                     "mobile":dict[ConstantString.k_Phone_Num.localized] as? String ?? "",
        "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
        "device_token": USER_DEVICE_TOKEN,
        "plateform": 2]
        WebServices.signup(params: params, success: { [weak self] (result) in
            guard let result = result else {return }
            self?.save_userData(data: result)
           // Global.showToast(msg: result["msg"].stringValue)
           
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    private func social_signup(){
        let params:JSONDictionary = ["email":dict[ConstantString.k_Email.localized] as? String ?? "" ,
                                     "username":dict[ConstantString.k_username.localized] as? String ?? "" ,
                                     "country_code":dict[ConstantString.K_Country_code.localized] as? String ?? "",
                                     "mobile":dict[ConstantString.k_Phone_Num.localized] as? String ?? "",
                                     "provider":self.provider,
                                     "uid":dict[ConstantString.k_user_uid.localized] as? String ?? ""]
        WebServices.social_signup(params: params, success: { [weak self]  (result) in
            guard let result = result else {return }
            self?.save_userData(data: result)
        }) {(error, code) in
            Global.showToast(msg: error)
        }
        
    }
    
    func error_Messages_forUniqueCheck(indexpath:IndexPath , isExists:Bool){
        if let cell = self.tableView.cellForRow(at: indexpath) as? TextFieldCell {
            if isExists{
                cell.errorLabelHeight.constant = 21
                cell.errorMessageLabel.isHidden = false
                errorMsg_arr[indexpath.row-1] = indexpath.row == 2 ? ConstantString.k_email_Exists.localized : ConstantString.k_username_Exixts.localized
                cell.errorMessageLabel.text = errorMsg_arr[indexpath.row-1]
                cell.textFIeld.addRightIcon(nil , imageSize: CGSize.zero)
            }
            else{
                 cell.errorLabelHeight.constant = 0
                 cell.errorMessageLabel.isHidden = true
                 cell.textFIeld.addRightIcon(#imageLiteral(resourceName: "icUsernameTick"), imageSize: CGSize(width: 30, height: 30))
                 errorMsg_arr[indexpath.row-1] = ""
                 cell.errorMessageLabel.text = ""
            }
        }
            
        else if let cell = self.tableView.cellForRow(at: indexpath) as? PhoneNumCell {
            if isExists{
                cell.errLabelHeight.constant = 21
                cell.errLabel.isHidden = false
                errorMsg_arr[indexpath.row-1] = ConstantString.k_phone_number_Exists.localized
                cell.errLabel.text = ConstantString.k_phone_number_Exists.localized
                cell.textField.addRightIcon(nil, imageSize: CGSize.zero)
            }
            else{
                cell.errLabelHeight.constant = 0
                cell.errLabel.isHidden = true
                errorMsg_arr[indexpath.row-1] = ""
                cell.errLabel.text = ""
                cell.textField.addRightIcon(#imageLiteral(resourceName: "icUsernameTick"), imageSize: CGSize(width: 30, height: 30))
            }
        }
        updateTableView()
    }
    
    // save User data in model
    private func save_userData(data: JSON){
         let result =  data["data"]
        currentUser.access_Token = result[ConstantString.k_Access_token.localized].stringValue
        if isSocialType{
            AppDelegate.shared?.tabBarScene = BaseTabBarVC.instantiate(fromAppStoryboard: .Home)
            Global.setRootController(vc: (AppDelegate.shared?.tabBarScene)!)
        }else{
            let otpVerifyScene = VerifyOtpVC.instantiate(fromAppStoryboard: .PreLogin)
            otpVerifyScene.otp_type = "3"
            otpVerifyScene.countryCode = dict[ConstantString.K_Country_code.localized] as? String
            otpVerifyScene.userPhoneNum = dict[ConstantString.k_Phone_Num.localized] as? String
            self.navigationController?.pushViewController(otpVerifyScene, animated: true)
        }
    }
}
