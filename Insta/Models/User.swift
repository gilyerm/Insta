//
//  User.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class User: NSObject,JsonProtocol {
    required init(json: [String : Any]) {
        self.userID = json["userID"] as! String;
        self.username = json["username"] as! String;
        self.password = json["password"] as! String;
        self.followers = json["followers"] as! [String];
        self.posts = json["posts"] as! [String];
        self.tags = json["tags"] as! [String];
        self.profilepic = URL(fileURLWithPath: json["profilepic"] as! String);
        self.details = json["details"] as! [String:String];
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["userID"] = userID
        json["username"] = username
        json["password"] = password
        json["followers"] = followers
        json["posts"] = posts
        json["tags"] = tags
        json["profilepic"] = profilepic.path
        json["details"] = details
        return json
    }
    
    
    var userID : String;
    var username : String;
    var password : String;
    var followers : [String]; // collection of user ids
    var posts : [String]; // collection of post ids
    var tags : [String]; // collection of post ids
    var profilepic : URL;
    var details : [String : String];
    
    init(userID:String,username:String,password:String,followers:[String],posts:[String],tags:[String],profilepic: URL ,details:[String:String]) {
        self.userID = userID;
        self.username = username;
        self.password = password;
        self.followers = followers;
        self.posts = posts;
        self.tags = tags;
        self.profilepic = profilepic;
        self.details = details;
    }
    init(userID:String,username:String,password:String) {
        self.userID = userID;
        self.username = username;
        self.password = password;
        self.followers = [String]();
        self.posts = [String]();
        self.tags = [String]();
        self.profilepic = URL(fileURLWithPath: "");
        self.details = [String : String]();
    }
}
