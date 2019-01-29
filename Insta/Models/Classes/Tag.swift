//
//  Tag.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class Tag: NSObject,JsonProtocol {
    
    var postID: String;
    var tags: [String]; // userid collection
    
    init(postID : String, tags: [String]) {
        self.postID = postID;
        self.tags = tags;
    }
    
    required init(json: [String : Any]) {
        self.postID = json["postID"] as! String;
        self.tags = json["tags"] as! [String];
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["postID"] = postID
        json["tags"] = tags
        return json;
    }
    
    
}
