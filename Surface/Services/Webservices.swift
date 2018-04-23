//
//  Webservices.swift
//  ArchievZ
//
//  Created by Nandini on 10/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

internal typealias success = ( _ data: JSON?) -> Void
internal typealias failure = ( _ errorMessage: String, _ errorCode: Int?) -> Void

var api_key : [String : String]{
    let dict:[String:String] = ["Authorization":"Basic c3VyZmFjZWFwcDpBZG0jJCVoZmdmY2NANDE="]
    return dict
}

var access_token : [String : String]{
    let dict:[String:String] = [ "access-token":  currentUser.access_Token , "Authorization":"Basic c3VyZmFjZWFwcDpBZG0jJCVoZmdmY2NANDE=" ]
    return dict
}

enum WebServices { }

extension NSError {
    
    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}


extension WebServices {
    
    //MARK:- All Post Methods
    static func signup(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.signUp.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func social_signup(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.user_social_signup.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func login(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.login.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func logout(success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.logout.url, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func send_Otp(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.user_sendOtp.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func forgotPassword(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.user_forgetPwd.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func resetPassword(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.user_reset_password.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func verifyOtp(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.user_verifyOtp.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func forgotUserName(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.user_forgetUsername.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func add_newPost(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.add_post.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func update_UserPost(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.update_post.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func delete_userPost(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.delete_post.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    static func update_UserProfile(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.profile_update.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    static func change_EmailPhone(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.profile_contact_change.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    static func update_EmailPhone(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        AppNetworking.POST(endPoint: EndPoint.profile_contact_update.url, parameters: params, headers: access_token, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    //MARK:- Error handling
    static func handleError(message:String?, errorCode:Any?, failure: failure?){
        guard errorCode != nil, let errCode = Int("\(errorCode!)") else {
            return
        }
        Global.print_Debug(message ?? "")
        failure?(message ?? "", errCode)
        
        if errCode == 401{
            Global.logOut()
        }
        else{
            Global.showToast(msg: message ?? "")
        }
    }
}
