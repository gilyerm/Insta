//
//  Comment.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Comment: NSObject,JsonProtocol {
    var postID: String; // post id
    var sender: String; // user id sender
    var messsage:  String;
    var timeSend: Date;
    
    init(postID: String,sender: String,messsage:String,timeSend: Date) {
        self.postID=postID;
        self.sender=sender;
        self.messsage=messsage;
        self.timeSend=timeSend;
    }
    
    required init(json: [String : Any]) {
        self.postID = json["postID"] as! String;
        self.sender = json["sender"] as! String;
        self.messsage = json["messsage"] as! String;
        self.timeSend = json["timeSend"] as! Date;
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["postID"] = postID
        json["sender"] = sender
        json["messsage"] = messsage
        json["timeSend"] = timeSend
        return json
    }
}
