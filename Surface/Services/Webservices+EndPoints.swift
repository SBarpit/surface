//
//  Webservices+EndPoints.swift
//  ArchievZ
//
//  Created by Nandini on 10/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

extension WebServices {
    enum EndPoint : String {
        
        case BaseUrl = "http://surfacestaging.appinventive.com/api/"

        case login               = "user/login"
        case signUp              = "user/signup"
        case logout              = "user/logout"
        case userCheck           = "user/check"
        case user_social_check   = "user/social_check"
        case user_social_signup  = "user/social_signup"
        case user_sendOtp        = "user/send_otp"
        case user_verifyOtp      = "user/verifyotp"
        case user_forgetUsername = "user/forget_username"
        case user_forgetPwd      = "user/forget_password"
        case user_reset_password = "user/reset_password"
        
        case user_by_location    = "search/user_by_location"
        
        case add_post            = "posts/add"
        case update_post    = "posts/update"
        case home_postList  = "posts"
        case delete_post    = "posts/delete"
        
        case comment_add = "posts/comment_add"
        case comment_reply = "posts/comment_reply"
        case comment_list = "posts/comments_list"
        case reply_list = "posts/replies_list"
      
        
        case profile_view   = "profile/view"
        case profile_update   = "profile/update"
        case profile_contact_change   = "profile/contact_change"
        case profile_contact_update   = "profile/update_contact"
        case get_notification_list    = "notification/list"
        case get_notification_read   = "notification/read"
        case get_notification_read_all    = "notification/read_all"
        case get_notification_unread_count   = "notification/unread_count"
        case get_friendList   = "friends/list"
        case get_friendList_request   = "friends/list_request"
        
        var url: String {
            switch self {
            case .BaseUrl:
                return self.rawValue
            default:
                return "\(EndPoint.BaseUrl.rawValue)\(self.rawValue)"
            }
        }
    }
}


