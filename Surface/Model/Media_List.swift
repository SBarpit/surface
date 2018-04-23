//
//  Media_List.swift
//  Surface
//
//  Created by Nandini Yadav on 22/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class Media_List: NSObject{
    
    var media_type: String?
    var media_url: String = ""
    var media_thumbnail: String = ""
   
    public required init?(json: JSON ){
        guard let type = json["type"].string else{
            return nil
        }
        media_type = type
        media_url = json["url"].stringValue
        media_thumbnail = json["thumbnail"].stringValue
    }
    override init(){
        
    }
    
    static func ==(left:Media_List, right:Media_List) -> Bool {
        return left.media_type == right.media_type
    }
}
