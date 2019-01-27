//
//  Like.swift
//  Insta
//
//  Created by Gil Yermiyah on 27/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class Like: NSObject,JsonProtocol {
    
    var likeID: String;
    var postID: String;
    var userID: String;
    
    init(likeID:String , postID : String, userID: String) {
        self.likeID = likeID;
        self.postID = postID;
        self.userID = userID;
    }
    
    required init(json: [String : Any]) {
        self.likeID = json["likeID"] as! String;
        self.postID = json["postID"] as! String;
        self.userID = json["userID"] as! String;
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["likeID"] = likeID
        json["postID"] = postID
        json["userID"] = userID
        return json;
    }
    
    
}
