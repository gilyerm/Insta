//
//  Post.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class Post : JsonProtocol{
    var caption : String
    var photoUrl : String
    
    required init(json: [String : Any]) {
        caption = json["caption"] as? String ?? ""
        photoUrl = json["photoUrl"] as? String ?? ""
    }
    
    func toJson() -> [String : Any] {
        var json = [String: Any]()
        json["caption"] = caption
        json["photoUrl"] = photoUrl
        return json
    }
    
    
    init(captionText : String , photoUrlString : String ) {
        self.caption = captionText
        self.photoUrl = photoUrlString
    }
}
