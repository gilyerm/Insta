//
//  Message.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var messageID: String;
    var sender: String; // user id
    var text: String; //the content of the message
    var time: Date; // when the user send the message
    
    init(messageID: String,sender: String,text: String,time: Date) {
        self.messageID=messageID;
        self.sender=sender;
        self.text=text;
        self.time=time;
    }
}
