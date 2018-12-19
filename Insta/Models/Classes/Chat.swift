//
//  Chat.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Chat: NSObject,JsonProtocol {
    
    var chatID: String;
    var users: [String]; // user ids size 2
    var messages: [Message]; // the chat
    
    init(chatID: String,users: [String]) {
        self.chatID=chatID;
        self.users = users;
        self.messages=[];
    }
    
    func sendMessage(message: Message){
        self.messages.append(message);
    }
    
    required init(json: [String : Any]) {
        self.chatID = json["chatID"] as! String;
        self.users = json["users"] as! [String];
        self.messages = json["messages"] as! [Message];
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["chatID"] = chatID
        json["users"] = users
        json["messages"] = messages
        return json
    }
    
}
