//
//  User.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class User {
    var email : String?
    var photoImageUrl : String?
    var username : String?
    
    
    init() {
        
    }
    init(email : String , photoImageUrl : String , username : String) {
        self.username = username
        self.photoImageUrl = photoImageUrl
        self.email = email
    }
    
}
extension User{
    
    static func transformUserFromJson(json : [String : Any]) -> User{
        let user : User = User()
        user.email = json["email"] as? String
        user.photoImageUrl = json["photoImageUrl"] as? String
        user.username = json["username"] as? String
        return user
    }
    
    
    static func transformUserToJson(user : User) -> [String : Any]{
        var json = [String: Any]()
        json["email"]           = user.email
        json["photoImageUrl"]   = user.photoImageUrl
        json["username"]        = user.username
        return json
    }
    
}
