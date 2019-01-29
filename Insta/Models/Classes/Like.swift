//
//  Like.swift
//  Insta
//
//  Created by Gil Yermiyah on 27/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class Like: NSObject,JsonProtocol {
    
    var postID: String;
    var likers: [String];
    
    init(postID : String, likers: [String]) {
        self.postID = postID;
        self.likers = likers;
    }
    
    required init(json: [String : Any]) {
        self.postID = json["postID"] as! String;
        self.likers = json["likers"] as! [String];
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["postID"] = postID
        json["likers"] = likers
        return json;
    }
    
    
}
