//
//  User.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var userID : String;
    var username : String;
    var password : String;
    var followers : [User];
    var posts : [Post];
    var tags : [Post];
    var details : [String : String];
    
    init(userID:String,username:String,password:String,followers:[User],posts:[Post],tags :[Post],details:[String:String]) {
        self.userID = userID;
        self.username = username;
        self.password = password;
        self.followers = followers;
        self.posts = posts;
        self.tags = tags;
        self.details = details;
    }
    init(userID:String,username:String,password:String) {
        self.userID = userID;
        self.username = username;
        self.password = password;
        self.followers = [];
        self.posts = [];
        self.tags = [];
        self.details = [:];
    }
}
