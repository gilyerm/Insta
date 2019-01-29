//
//  User.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class User: NSObject,JsonProtocol {
    var userID : String; /// from FireBase Auth
    var username : String;
    var email : String;
    var profilepic : String; //path to url
    var details : [String : String];
    var lastUpdate:Double?
    
    init(userID:String,username:String,email:String,profilepic: String ,details:[String:String]) {
        self.userID = userID;
        self.username = username;
        self.email = email;
        self.profilepic = profilepic;
        self.details = details;
    }
    init(userID:String,username:String,email:String) {
        self.userID = userID;
        self.username = username;
        self.email = email;
        self.profilepic = "";
        self.details = [String : String]();
    }
    
    required init(json: [String : Any]) {
        self.userID = json["userID"] as! String;
        self.username = json["username"] as! String;
        self.email = json["email"] as! String;
        if json["profilepic"] != nil{
            self.profilepic = json["profilepic"] as! String
        }else{
            self.profilepic = ""
        }
        self.details = json["details"] as! [String:String];
        if json["lastUpdate"] != nil {
            if let lud = json["lastUpdate"] as? Double{
                lastUpdate = lud
            }
        }
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["userID"] = userID
        json["username"] = username
        json["email"] = email
        json["profilepic"] = profilepic
        json["details"] = details
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
    
}
