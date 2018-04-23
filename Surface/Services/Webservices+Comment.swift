//
//  Webservices + Comment.swift
//  Surface
//
//  Created by Appinventiv Mac on 06/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
var Comments:Comment!

extension WebServices {
    
    // MARK: Methods to add comments
    
    static func add_comment(params : JSONDictionary , success : @escaping (String) -> () , failure: @escaping failure){
        
        AppNetworking.POST(endPoint: EndPoint.comment_add.url,parameters : params,headers: access_token,loader : false, success: { (result) in
            
            print(result)
            if result["code"].intValue == 200 {
                let _ = Comment.init(data: result)
                success(" Posted Successfully ")
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
        },failure : { (error) in
            failure(error.localizedDescription,nil)
        })
    }
    
    
    // Methods to add reply to comments
    
    static func reply_comment(params: JSONDictionary, success : @escaping (String) -> () , failure : @escaping failure){
        
        AppNetworking.POST(endPoint: EndPoint.comment_reply.url,parameters : params,headers: access_token,loader : false, success: { (result) in
            if result["code"].intValue == 200 {
                success(" Replyed Succesfully ")
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
        },failure :{ (error) in
            failure(error.localizedDescription,nil)
            
        })
        
    }
    
    // MARK: Methods to get replies list
    
    static func list_reply(params: JSONDictionary, success : @escaping (Replies) -> () , failure : @escaping failure){
        AppNetworking.GET(endPoint: EndPoint.reply_list.url, parameters: params, headers: access_token, loader:true,  success: { (result) in
            
            if result["code"].intValue == 200{
                let replies = Replies.init(result)
                success(replies)
                
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
            
        },failure : { (error) in
            failure(error.localizedDescription, nil)
        })
    }
    
    
    // MARK: Methods to get all comment list
    
    static func list_comment(params: JSONDictionary, success : @escaping (Comment) -> () , failure : @escaping failure){
        print(params)
        AppNetworking.GET(endPoint: EndPoint.comment_list.url, parameters: params, headers: access_token, loader:true,  success: { (result) in
            if result["code"].intValue == 200{
                let results = Comment.init(data: result)
                success(results)
            } else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
        },failure : { (error) in
            failure(error.localizedDescription, nil)
        })
    }
}
