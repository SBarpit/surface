//
//  NearbyUserModel.swift
//  Surface
//
//  Created by Appinventiv Mac on 11/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON


struct NearBy {
    
    var msg : String?
    var total : String?
    var data : [Results]?
    
    
    init(_ data:JSON) {
        self.msg = data["msg"].stringValue
        self.total = data["total"].stringValue
        let dataArray = data["data"].arrayValue
        self.data = dataArray.map({ Results.init($0)})
    }
}


struct Results {
    var user_id : String?
    var name : String?
    var user_name : String?
    var profile_thumb : String?
    var location : String?
    var lattitude : String?
    var longitude : String?
    var is_friend : String?
    
    
    init(_ data: JSON){
        self.user_id = data["user_id"].stringValue
        self.name = data["name"].stringValue
        self.user_name = data["user_name"].stringValue
        self.profile_thumb = data["profile_thumb"].stringValue
        self.location = data["location"].stringValue
        self.lattitude = data["lattitude"].stringValue
        self.longitude = data["longitude"].stringValue
        self.is_friend = data["is_friend"].stringValue
        
    }
}



/*
 {
 "msg": "List Success",
 "total": "1",
 "data": [
 {
 "user_id": "1",
 "name": "Durgesh",
 "user_name": "dcm",
 "profile_thumb": "http://xyz.com/123.jpg",
 "location": "NOIDA",
 "lattitude": "28.628151",
 "longitude": "77.367783",
 "is_friend": true
 }
 ]
 }
 */

