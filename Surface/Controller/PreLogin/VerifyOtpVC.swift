//
//  VerifyOtpVC.swift
//  Surface
//
//  Created by Nandini Yadav on 09/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit


protocol UpdatePhoneNumber:class {
    func updateNumber(phone:String)
}

class VerifyOtpVC: BaseSurfaceVC {

    enum Flow{
        case changePhone
        case signup
        
    }
    //MARK:- Properties
    var pin: String = ""
    var otp_type:String?
    var userPhoneNum:String?
    var countryCode:String?
    var flow = Flow.signup
    weak var updatePhoneNumberDelegate: UpdatePhoneNumber?
    
    //MARK:- @IBOutlets
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var VerifyButton: UIButton!
    @IBOutlet weak var firstTextField       : UITextField!
    @IBOutlet weak var secondTextField      : UITextField!
    @IBOutlet weak var thirdTextField       : UITextField!
    @IBOutlet weak var fourthTextField      : UITextField!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstTextField.cornerRadius(radius: 6)
        secondTextField.cornerRadius(radius:6)
        thirdTextField.cornerRadius(radius: 6)
        fourthTextField.cornerRadius(radius: 6)
        
        VerifyButton.layer.borderColor = Global.getGradientImage_Color(size: VerifyButton.size)?.cgColor
        VerifyButton.cornerRadius(radius: VerifyButton.h/2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    private func setUpSubView() {
        // set gradient color on login border
        VerifyButton.backgroundColor = .white
        VerifyButton.layer.borderWidth = 1.0
        
        let textSize = Global.textSizeCount(VerifyButton.currentTitle, font: (VerifyButton.titleLabel?.font)!, bundingSize: CGSize(width: 60, height: 1000))
        VerifyButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
        
        self.firstTextField.delegate = self
        self.secondTextField.delegate = self
        self.thirdTextField.delegate = self
        self.fourthTextField.delegate = self
        
        if var mobile = userPhoneNum , let code = countryCode{
            Global.print_Debug(mobile)
            let startIndex = mobile.index(mobile.startIndex, offsetBy: mobile.count/2)
            let endIndex = mobile.index(mobile.startIndex, offsetBy: mobile.count)
            let reminder = mobile.count%2
            let x_Str = String(repeating: "X", count: (mobile.count/2)+reminder)
            let range: Range = Range.init(uncheckedBounds: (lower: startIndex, upper: endIndex))
            
            mobile.replaceSubrange(range, with: x_Str)
            Global.print_Debug(mobile)
        
            descLabel.text = ConstantString.k_Otp_sent_on.localized + "\(code) " + "\(mobile)"
        }
        
    }
    
    
    //MARK:- @IBActions & Methods
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if pin.length < 4{
            Global.showToast(msg: ConstantString.k_valid_pin.localized)
        }else{
           Global.print_Debug("OTP:-\(pin)")
            if flow == .signup {
                
            verify_otp()
            }else{
               updatePhoneNumber()
                
            }
        }
    }
}

extension VerifyOtpVC{
    
    //MARK:- Removing Spaces and special characters
    //=============================================
    func textFieldShouldHighLight() {
        
        if let text1 = self.firstTextField.text,
            let text2 = self.secondTextField.text,
            let text3 = self.thirdTextField.text,
            let text4 = self.fourthTextField.text {
            
            firstTextField.backgroundColor = !text1.removingWhitespaces.isEmpty ?  #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1) : #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
            secondTextField.backgroundColor = !text2.removingWhitespaces.isEmpty ?  #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1) : #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
            thirdTextField.backgroundColor = !text3.removingWhitespaces.isEmpty ?  #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1) : #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
            fourthTextField.backgroundColor = !text4.removingWhitespaces.isEmpty ?  #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1) : #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
           
            if text1.removingWhitespaces != "\u{200B}" && !text1.isEmpty && text2.removingWhitespaces != "\u{200B}" && !text2.isEmpty && text3.removingWhitespaces != "\u{200B}" && !text3.isEmpty && text4.removingWhitespaces != "\u{200B}" && !text4.isEmpty {
                
                self.pin = "\(text1)\(text2)\(text3)\(text4)"
                Global.print_Debug("OTP:-\(pin)")
                self.firstTextField.backgroundColor     = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
                self.secondTextField.backgroundColor    = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
                self.thirdTextField.backgroundColor     = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
                self.fourthTextField.backgroundColor    = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
                
            }
        }
    }

}


//MARK: Extension of VerifyOtpVC : for UITextFieldDelegate
//==============================================================
extension VerifyOtpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Moving responder to next textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.containsEmoji || string == " "{
            return false
        }
        
        if (textField == self.firstTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                self.secondTextField.becomeFirstResponder()
            }
            else
            {
                textField.text = ""
            }
        }
        else if (textField == self.secondTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                self.thirdTextField.becomeFirstResponder()
            }
            else
            {
                textField.text = ""
                self.firstTextField.becomeFirstResponder()
            }
        }
            
        else if (textField == self.thirdTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                self.fourthTextField.becomeFirstResponder()
            }
            else
            {
                textField.text = ""
                self.secondTextField.becomeFirstResponder()
            }
        }
        else if (textField == self.fourthTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                textField.resignFirstResponder()
            }
            else
            {
                textField.text = ""
                self.thirdTextField.becomeFirstResponder()
            }
        }
        self.textFieldShouldHighLight()
        return false
    }
    
}

//MARK:- Webservices
extension VerifyOtpVC{
    func verify_otp(){
        let params : JSONDictionary = ["otp": self.pin , "send_to": otp_type ?? ""]
        
        WebServices.verifyOtp(params: params, success: {[weak self] (result) in
            guard let result = result?["data"] else {return }
            guard User(json: result) != nil else {
                return
            }
            Global.showToast(msg: result["msg"].stringValue)
            if let otpType = self?.otp_type , otpType == "3"{
                let tabBarScene = BaseTabBarVC.instantiate(fromAppStoryboard: .Home)
                Global.setRootController(vc: tabBarScene)
            }else{
                 self?.navigationController?.popViewController(animated: true)
            }
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    func updatePhoneNumber(){
        
        let params : JSONDictionary = ["token": self.pin , "mobile":self.userPhoneNum ?? "" ,"country_code":self.countryCode ?? ""]
        
        WebServices.update_EmailPhone(params: params, success: {[weak self] (result) in
            guard let result = result?["data"] else {return }
          
            Global.showToast(msg: result["msg"].stringValue)
           // self?.updatePhoneNumberDelegate = self as? UpdatePhoneNumber
            
            if let viewControllers = self?.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController.isKind(of: EditProfileVC.self) {
                        print("Class is available")
                        
                        self?.updatePhoneNumberDelegate?.updateNumber(phone: self?.userPhoneNum ?? "")
                        
                        self?.navigationController?.popToViewController(viewController, animated: true)
                    }
                }
            }
                //let editProfile = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
             //   self?.navigationController?.pushViewController(, animated: true)
           
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
}
