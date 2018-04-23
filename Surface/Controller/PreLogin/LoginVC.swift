//
//  LoginVC.swift
//  Surface
//
//  Created by Nandini on 06/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON
class LoginVC: BaseSurfaceVC {
    //MARK:- Properties
    
    var reset_token:String?
   
    //MARK:- @IBOutlets
    @IBOutlet weak var appLogoImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var dontHaveAnAccountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var continueLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.cornerRadius(radius: emailTextField.h/2)
        emailTextField.add_LeftPadding(paddingSize: 20)
        
        passwordTextField.cornerRadius(radius: passwordTextField.h/2)
        passwordTextField.add_LeftPadding(paddingSize: 20)
        
        loginButton.layer.borderColor = Global.getGradientImage_Color(size: loginButton.size)?.cgColor
        loginButton.cornerRadius(radius: loginButton.h/2)
        facebookButton.cornerRadius(radius: facebookButton.h/2)
        googleButton.cornerRadius(radius: googleButton.h/2)
        signupButton.cornerRadius(radius: signupButton.h/2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = reset_token{
            let resetPwd = ResetPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
            resetPwd.resetPwd_token = token
            self.navigationController?.pushViewController(resetPwd, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.reset_token = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    private func initialSetup() {
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_userOrEmail.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: ConstantString.k_password.localized, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.5)])
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        
        // set gradient color on login border
        loginButton.backgroundColor = .white
        loginButton.layer.borderWidth = 1.0
       
        let textSize = Global.textSizeCount(loginButton.currentTitle, font: (loginButton.titleLabel?.font)!, bundingSize: CGSize(width: 60, height: 1000))
        
        loginButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
    }
    
    // validate All FIelds
    private func validateAllField()-> Bool{
        if DidValidate.isBlank(txt:self.emailTextField.text){
            Global.showToast(msg: ConstantString.k_Empty_email.localized)
            return false
        }
//        if let email = self.emailTextField.text ,  !email.isEmpty && !DidValidate.isValidEmail(email: email){
//            Global.showToast(msg: ConstantString.k_Valid_email_war.localized)
//            return false
//        }
        if DidValidate.isBlank(txt: passwordTextField.text){
            Global.showToast(msg: ConstantString.k_Empty_pwd_war.localized)
            return false
        }
        if DidValidate.isInvalidPwd(txt: passwordTextField.text){
            Global.showToast(msg: ConstantString.k_Pwd_length_war.localized)
            return false
        }
        return true
    }
    
    private func alert_ForgotLoginDetail(){
        let alertController = UIAlertController (title: "Forgot Login Details?", message: nil, preferredStyle: .alert)
        
        let passwordAction = UIAlertAction(title:"Forgot Password", style: .default) { (_) -> Void in
            
            let passwordScene = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
            self.navigationController?.pushViewController(passwordScene, animated: true)
        }
        
        let usernameAction = UIAlertAction(title: "Forgot Username", style: .default) { (_) in
            let usernameScene = ForgotUsernameVC.instantiate(fromAppStoryboard: .PreLogin)
            self.navigationController?.pushViewController(usernameScene, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            
        }
        alertController.addAction(passwordAction)
        alertController.addAction(usernameAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- @IBActions & Methods
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        alert_ForgotLoginDetail()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateAllField(){
           login()
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        FacebookController.facebookLogin(viewController: self, success: { (modelValue: model) in
            // Do code here like that to get further details.
            Global.print_Debug("name:- \(modelValue.name ?? "")")
            let dict :JSONDictionary =  [ConstantString.k_Email.localized : modelValue.email ?? "", ConstantString.k_user_uid.localized : modelValue.fbId ?? ""]
             // check social account is exists or not
            self.isSocial_Account_exists(provider: "facebook", dict: dict)
        }) { (err : Error) in
            Global.print_Debug(err.localizedDescription)
        }
       
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        GoogleLoginController.shared.login(success: { (model :  GoogleUser) in
            Global.print_Debug("name:- \(model.name)")
            Global.print_Debug("email:- \( model.email)")
            Global.print_Debug("image:- \(model.image?.absoluteString ?? "")")
            let dict :JSONDictionary =  [ConstantString.k_Email.localized : model.email , ConstantString.k_user_uid.localized : model.id]
            // check social account is exists or not
            self.isSocial_Account_exists(provider: "google", dict: dict)
        })
        { (err : Error) in
            print(err.localizedDescription)
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let signupScene = SignupVC.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(signupScene, animated: true)
    }
    
    @objc func textFieldDidEditingChanged(_ sender: UITextField) {
        guard let txt = sender.text else {
            Global.print_Debug("text is empty")
            return
        }
        if sender === emailTextField{
            emailTextField.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
            emailTextField.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        }else{
            passwordTextField.layer.borderColor = txt.isEmpty ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : AppColors.appBorderLineGray.cgColor
            passwordTextField.backgroundColor = txt.isEmpty ? #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        }
        self.view.layoutIfNeeded()
    }
}

extension LoginVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField{
            passwordTextField.becomeFirstResponder()
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
        
        if textField === self.passwordTextField{
            return newString.length <= 15
        }
        return newString.length <= 60
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
}

//MARK:- Webservices
extension LoginVC{
    
    func isSocial_Account_exists(provider:String , dict: JSONDictionary){
        let params:JSONDictionary = ["provider":provider,"uid":dict[ConstantString.k_user_uid.localized] as? String ?? ""]
        
        WebServices.social_check(params:params , success: { [weak self] (result) in
            guard let result = result else {return }
            Global.print_Debug(result)
            if result["status"].boolValue{
               self?.save_userData(data: result["data"])
            }else{
                let signupScene = SignupVC.instantiate(fromAppStoryboard: .PreLogin)
                signupScene.isSocialType = true
                signupScene.provider = provider
                signupScene.dict = dict
                self?.navigationController?.pushViewController(signupScene, animated: true)
            }
        
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    func login(){
        let params:JSONDictionary = ["username":emailTextField.text ?? "",
                                     "password":passwordTextField.text ?? "",
                                     "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                                     "device_token": USER_DEVICE_TOKEN,
                                     "plateform": 2]

        WebServices.login(params: params, success: { [weak self] (result) in
            guard let result = result else {return }
            Global.print_Debug(result)
            self?.save_userData(data: result["data"])
            
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    // save User data in model
    private func save_userData(data: JSON){
        guard User(json: data) != nil else {
            return
        }
        if !currentUser.id.isEmpty{
            AppDelegate.shared?.tabBarScene = BaseTabBarVC.instantiate(fromAppStoryboard: .Home)
            Global.setRootController(vc: (AppDelegate.shared?.tabBarScene)!)
        }
    }
}
