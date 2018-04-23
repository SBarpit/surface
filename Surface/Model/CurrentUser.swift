//
//  CurrentUser.swift
//  Surface
//
//  Created by Nandini Yadav on 12/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

var currentUser = User.shared

class User{
    
    static var shared = User()
    
    public required init?(json: JSON) {
        guard let rID = json[ConstantString.k_user_Id.localized].string else{
            Global.print_Debug("user_id is not found")
            return
        }
        currentUser.id = rID
        currentUser.email              = json[ConstantString.k_user_email.localized].stringValue
        currentUser.access_Token       = json[ConstantString.k_Access_token.localized].stringValue
        currentUser.phoneNum           = json[ConstantString.k_Mobile.localized].stringValue
        currentUser.username           = json[ConstantString.k_user_name.localized].stringValue
        currentUser.country_Code       = json[ConstantString.k_Country_code.localized].stringValue
        
    }
    
    init(){
        
    }
    
    // MARK:- Set Or Get value Of Current User
    
    var user_Image: String{
        set{
            AppUserModel.save(value: newValue, forKey: .user_image)
        }get {
            return AppUserModel.value(forKey: .user_image).stringValue
        }
    }
    
    var did_run_first_time_App: Bool{
        set{
            AppUserModel.save(value: newValue, forKey: .did_runFirstTime)
        }get {
            return AppUserModel.value(forKey: .did_runFirstTime).boolValue
        }
    }
    
    var id: String{
        set{
            AppUserModel.save(value: newValue, forKey: .user_id)
        }get {
            return AppUserModel.value(forKey: .user_id).stringValue
        }
    }
    
    var country_Code: String{
        set{
            AppUserModel.save(value: newValue, forKey: .country_code)
        }get {
            return AppUserModel.value(forKey: .country_code).stringValue
        }
    }
    
    var username: String{
        set{
            AppUserModel.save(value: newValue, forKey: .username)
        }get {
            return AppUserModel.value(forKey: .username).stringValue
        }
    }
    
    var social_id: String{
        set{
            AppUserModel.save(value: newValue, forKey: .social_id)
        }get {
            return AppUserModel.value(forKey: .social_id).stringValue
        }
    }
    
    var social_type: String{
        set{
            AppUserModel.save(value: newValue, forKey: .social_type)
        }get {
            return AppUserModel.value(forKey: .social_type).stringValue
        }
    }
    

    var deviceToken: String{
        set{
            AppUserModel.save(value: newValue, forKey: .device_Token)
        }get {
            return AppUserModel.value(forKey: .device_Token).stringValue
        }
    }
    
    var email: String{
        set{
            AppUserModel.save(value: newValue, forKey: .email)
        }get {
            return AppUserModel.value(forKey: .email).stringValue
        }
    }
    
    var phoneNum: String{
        set{
            AppUserModel.save(value: newValue, forKey: .mobile)
        }get {
            return AppUserModel.value(forKey: .mobile).stringValue
        }
    }
    
    var access_Token: String{
        set{
            AppUserModel.save(value: newValue , forKey: .accessToken)
        }get {
            return AppUserModel.value(forKey: .accessToken).stringValue
        }
    }
    
}

