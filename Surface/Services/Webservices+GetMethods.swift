//
//  Webservices+GetMethods.swift
//  InvoiZ
//
//  Created by Nandini on 14/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

extension WebServices {
    
    // get folder List
    static func check_username(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.userCheck.url, parameters: params, headers: api_key, loader: false ,  success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    // get folder List
    static func social_check(params : JSONDictionary , success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.user_social_check.url, parameters: params, headers: api_key, success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    // get folder List
    static func get_home_postList(params : JSONDictionary ,loader:Bool ,  success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.home_postList.url, parameters: params, headers: access_token, loader:loader,  success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    // Get Profile Info
    //=================
    static func get_Profile_API(params : JSONDictionary ,loader:Bool ,  success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.profile_view.url, parameters: params, headers: access_token, loader:loader,  success: { (result) in
            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    // get Notification List
    static func getNotificationList(params : JSONDictionary ,loader:Bool ,  success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.get_notification_list.url, parameters: params, headers: access_token, loader:loader,  success: { (result) in

            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    // get Friend List
    static func getFriendList(params : JSONDictionary ,loader:Bool ,  success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.get_friendList.url, parameters: params, headers: access_token, loader:loader,  success: { (result) in
            
            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
    // get Friend List
    static func getFriendListRequest(params : JSONDictionary ,loader:Bool ,  success : @escaping success , failure: @escaping failure){
        
        AppNetworking.GET(endPoint: EndPoint.get_friendList_request.url, parameters: params, headers: access_token, loader:loader,  success: { (result) in
            
            if result["code"].intValue == 200{
                success(result)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        }) { (error) in
            failure(error.localizedDescription, nil)
        }
    }
    
}

