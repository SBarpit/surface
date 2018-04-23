//
//  CommentModel.swift
//  Surface
//
//  Created by Appinventiv Mac on 06/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Comment {
    var status : Bool?
    var data : [Datas]?
    
    init(data:JSON) {
        
        self.status = data["status"].boolValue ?? false
        
        let dataArray = data["data"].arrayValue
        self.data = dataArray.map({ Datas.init($0)}) ?? []
    }
}

struct Datas {
    
    var id : String?
    var user_id : String?
    var user_name : String?
    var profile_thumb : String?
    var comment : String?
    var replies : [Replies]?
    
    init(_ data:JSON) {
        
        self.id = data["id"].stringValue ?? ""
        self.user_id = data["user_id"].stringValue ?? ""
        self.user_name = data["user_name"].stringValue ?? ""
        self.profile_thumb = data["profile_thumb"].stringValue ?? ""
        self.comment = data["comment"].stringValue ?? ""
        
        let repliesArray = data["replies"].arrayValue
        self.replies = repliesArray.map({ Replies.init($0)}) ?? []
    }
}

struct Replies {
    
    var id : String?
    var user_id : String?
    var user_name : String?
    var profile_thumb : String?
    var comment : String?
    
    init(_ data:JSON) {
        
        self.id = data["id"].stringValue ?? ""
        self.user_id = data["user_id"].stringValue ?? ""
        self.user_name = data["user_name"].stringValue ?? ""
        self.profile_thumb = data["profile_thumb"].stringValue ?? ""
        self.comment = data["comment"].stringValue ?? ""
    }
}



// MARK: MODEL using decoder

//
//struct Comment : Decodable{
//    var status : Bool
//    var data : [Datas]
//}
//struct Datas : Decodable {
//    var id : String
//    var user_id : String
//    var user_name : String
//    var profile_thumb : String
//    var comment : String
//    var replies : [Replies]
//}
//
//struct Replies : Decodable{
//    var id : String
//    var user_id : String
//    var user_name : String
//    var profile_thumb : String
//    var comment : String
//}



