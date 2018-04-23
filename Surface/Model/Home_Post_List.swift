//
//  Home_Post_List.swift
//  Surface
//
//  Created by Nandini Yadav on 22/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class Home_Post_List{
    
        init(){

        }
}


class Featured_List: NSObject{
    
    var featured_id: String?
    var user_id:String?
    var desc: String = ""
    var lattitude: String = ""
    var tags: String = ""
    var comments_count: Int32 = 0
    var location: String = ""
    var shares_count: Int32 = 0
    var created_at: String = ""
    var user_name: String = ""
    var views_count: Int32 = 0
    var longitude: String = ""
    var media_arr = [Media_List]()
    
    var deal_created_on: Date?
    var privous_TimeOfPost: String = ""
    
    public required init?(json: JSON ){
        guard let rID = json["id"].string else{
            return nil
        }
        featured_id     = rID
        user_id         = json["user_id"].string
        desc            = json["description"].stringValue
        lattitude       = json["lattitude"].stringValue
        tags            = json["tags"].stringValue
        comments_count  = json["comments_count"].int32Value
        location        = json["location"].stringValue
        shares_count    = json["shares_count"].int32Value
        created_at      = json["created_at"].stringValue
        user_name       = json["user_name"].stringValue
        longitude       = json["longitude"].stringValue
        views_count     = json["views_count"].int32Value
        
        deal_created_on =  Global.convertStringIntoDate(format: "yyyy-MM-dd HH:mm:ss", date: json["created_at"].stringValue ,timeZone:  TimeZone(abbreviation: "UTC"))
        self.privous_TimeOfPost = deal_created_on?.timeAgo ?? ""
        
        for data in json["media"].arrayValue{
            guard let mediaData = Media_List(json : data) else { return }
            media_arr.append(mediaData)
        }
    }
    
    override init(){
        
    }
    
    static func ==(left:Featured_List, right:Featured_List) -> Bool {
        return left.featured_id == right.featured_id
    }

}
