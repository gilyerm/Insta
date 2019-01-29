//
//  Following.swift
//  Insta
//
//  Created by admin on 27/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Following: NSObject,JsonProtocol {
    var userID : String; /// from FireBase Auth
    var followed : [String];
    
    init(userID:String) {
        self.userID = userID;
        self.followed = [String]();
    }
    
    init(userID:String , followed : [String]) {
        self.userID = userID;
        self.followed = followed;
    }
    
    required init(json: [String : Any]) {
        self.userID = json["userID"] as! String;
        self.followed = json["followed"] as! [String];
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["userID"] = userID
        json["followed"] = followed
        return json
    }

}
