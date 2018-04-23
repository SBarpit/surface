//
//  editProfileModel.swift
//  Surface
//
//  Created by Arvind Rawat on 03/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 {
 "updated_at" : "2018-04-03 13:23:06",
 "is_friend" : false,
 "profile_image" : "",
 "push_notification" : 0,
 "bio" : "",
 "profile_thumb" : "",
 "posts_count" : "0",
 "weblink" : "",
 "created_at" : "2018-04-03 13:23:06",
 "friends" : 0,
 "user_id" : "41",
 "user_name" : "Arvind",
 "company" : "",
 "dob" : "0000-00-00"
 },
 "code" : 200,
 "msg" : "Profile Data"
 }
 */

class UserInfoModel {
    
    var user_name            : String = ""
    var display_name         : String = ""
    var updated_at           : String = ""
    var is_friend            : Bool   = false
    var profile_image        : String = ""
    var push_notification    : Int    = 0
    var bio                  : String = ""
    var profile_thumb        : String = ""
    var posts_count          : String = ""
    var weblink              : String = ""
    var created_at           : String = ""
    var friends              : Int    = 0
    var user_id              : String = ""
    var company              : String = ""
    var dob                  : String = ""
    var gender               : String = ""
    var location             : String = ""
    var link                 : String = ""
    var email                : String = ""
    var mobile               : String = ""
    
    
    convenience init(_ dict : JSON) {
        self.init()
        
        user_name               = dict["user_name"].stringValue
        display_name               = dict["display_name"].stringValue
        updated_at              = dict["updated_at"].stringValue
        is_friend               = dict["is_friend"].boolValue
        profile_image           = dict["profile_image"].stringValue
        push_notification       = dict["push_notification"].intValue
        bio                     = dict["bio"].stringValue
        profile_thumb           = dict["profile_thumb"].stringValue
        posts_count             = dict["posts_count"].stringValue
        weblink                 = dict["weblink"].stringValue
        created_at              = dict["created_at"].stringValue
        friends                 = dict["friends"].intValue
        user_id                 = dict["user_id"].stringValue
        company                 = dict["company"].stringValue
        dob                     = dict["dob"].stringValue
        gender                  = dict["gender"].stringValue
        location                = dict["location"].stringValue
        link                    = dict["link"].stringValue
        email                   = dict["email"].stringValue
        mobile                  = dict["mobile"].stringValue
        
    }
    
    
    func convertToDictionary(_ forApi : Bool)->[String : Any]{
        
        var dict = [String : Any]()
        
        if forApi{
            
            dict["user_name"]     = user_name
            dict["display_name"]  = display_name
            dict["bio"]           = bio
            dict["email"]         = email
            dict["location"]      =  location
            dict["gender"]        = gender
            dict["profile_image"] = profile_image
            dict["profile_thumb"] = profile_thumb
            
            return dict
            
        }else{
            
            //            dict["first_name"]   = first_name
            //            dict["image"]        = image
            //            dict["last_name"]    = last_name
            //            dict["email"]        = email
            //            dict["access_token"] = access_token
            //            dict["address"]      = address
            //            dict["country_id"]   = country_id
            //            dict["state_id"]     = state_id
            //            dict["city_id"]      =  city_id
            return dict
        }
        
    }
}
