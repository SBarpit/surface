//
//  ChangePhoneNumberVC.swift
//  Surface
//
//  Created by Arvind Rawat on 04/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ChangePhoneNumberVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var countryCodeBtn: UIButton!
   
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- FUNCTIONS
    //================
    func initialSetup(){
       
        sendOtpBtn.layer.borderColor = Global.getGradientImage_Color(size: sendOtpBtn.size)?.cgColor
        sendOtpBtn.cornerRadius(radius: sendOtpBtn.h/2)
        // set gradient color on login border
        sendOtpBtn.backgroundColor = .white
        sendOtpBtn.layer.borderWidth = 1.0
        
         countryCodeBtn.titleLabel?.font = AppFonts.medium.withSize(13.5)
         countryCodeBtn.setTitle("+91", for: .normal)
        
        let textSize = Global.textSizeCount(sendOtpBtn.currentTitle, font: (sendOtpBtn.titleLabel?.font)!, bundingSize: CGSize(width: 60, height: 1000))
        sendOtpBtn.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
        
        outerView.cornerRadius(radius: numberTextField.h/2)
        numberTextField.add_LeftPadding(paddingSize: 20)
        outerView.layer.borderWidth = 0.5
        outerView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        outerView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        numberTextField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_Phone_Num.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        numberTextField.delegate = self
        
    }
    
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendOtpBtnAction(_ sender: UIButton) {
        
        changePhone()
        
    }
    
    @IBAction func countryCodeBtnAction(_ sender: UIButton) {
        let countryCodeScene = CountryCodeVC.instantiate(fromAppStoryboard: .PreLogin)
        countryCodeScene.delegate = self
        self.navigationController?.pushViewController(countryCodeScene, animated: true)
        
        
    }
}

//MARK:- EXTENSION UITEXTFIELDDELEGATE
//====================================
extension ChangePhoneNumberVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.keyboardType  = .numberPad
        textField.returnKeyType = .done
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
  
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji{
            return false
        }
        
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        
        return newString.length <= 15
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
}

//MARK:- SetContryCode Delegate
//=============================
extension ChangePhoneNumberVC : SetContryCodeDelegate {
    
    func setCountryCode(country_info: JSONDictionary) {
        let code = "+\(country_info["CountryCode"] ?? "+91")"
        countryCodeBtn.setTitle(code, for: .normal)
        countryCodeBtn.setTitleColor(#colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1), for: .normal)
       
    }
}



//MARK:- EXTENSION API
//====================================
extension ChangePhoneNumberVC{

    func check_usernameAndPhoneNum(_ params :JSONDictionary , indexpath : IndexPath){
    WebServices.check_username(params: params, success: {  [weak self] (result) in
        guard let result = result else {return }
        
        self?.error_Messages_forUniqueCheck(indexpath: indexpath, isExists: result["status"].boolValue)
        
    }) {(error, code) in
        Global.showToast(msg: error)
    }
}
    
    func error_Messages_forUniqueCheck(indexpath:IndexPath , isExists:Bool){
        if isExists{
            
            numberTextField.addRightIcon(nil , imageSize: CGSize.zero)
        }
        else{
            
            numberTextField.addRightIcon(#imageLiteral(resourceName: "icUsernameTick"), imageSize: CGSize(width: 30, height: 30))
        }
    }
    

    func changePhone(){
        
        var param = JSONDictionary()
        param["mobile"] = numberTextField.text
        param["country_code"] = self.countryCodeBtn.currentTitle
        
        WebServices.change_EmailPhone(params: param, success: { (results) in
            if let result = results?.dictionaryValue{
                
                if let status = result["status"]?.boolValue{
                    if let message = result["msg"]?.stringValue{
                        Global.showToast(msg: message)
                    }
                    
                    if status{
                        
                        
                        let otpVC = VerifyOtpVC.instantiate(fromAppStoryboard: .PreLogin)
                        otpVC.flow = .changePhone
                        otpVC.userPhoneNum = self.numberTextField.text
                        otpVC.countryCode = self.countryCodeBtn.currentTitle
                        self.navigationController?.pushViewController(otpVC, animated: true)
                    }else{
                        
                        
                        
                    }
                }
            }
            
            
        }) { (error, code) in
            
            Global.showToast(msg: error.localized)
        }
    }
}



