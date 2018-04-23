//
//  Webservice + Nearby.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

extension WebServices {
    
    // MARK: Methods to add comments
    
    static func user_byLocation(params : JSONDictionary , success : @escaping (NearBy) -> () , failure: @escaping (String,Int?) ->()){
        
        AppNetworking.GET(endPoint: EndPoint.user_by_location.url,parameters : params,headers: access_token,loader : true, success: { (result) in
            if result["msg"].stringValue == "List Success" {
                let nearby = NearBy.init(result)
                success(nearby)
            }else{
                handleError(message: result["msg"].stringValue, errorCode: result["code"].intValue, failure: failure)
            }
        },failure : { (error) in
            failure(error.localizedDescription,nil)
        })
}
    
}
