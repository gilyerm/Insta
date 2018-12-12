//
//  Comment.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Comment: NSObject {
    
    var commentID: String;
    var postID: String; // post id
    var sender: String; // user id sender
    var messsage:  String;
    var reply: String?; // comment id that the sender reply on
    
    init(commentID: String,postID: String,sender: String,messsage:String,reply: String?) {
        self.commentID=commentID;
        self.postID=postID;
        self.sender=sender;
        self.messsage=messsage;
        self.reply=reply;
    }
}
