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
    var profileImageUrl : String?
    var username : String?
    var id : String?
    var isFollowing: Bool?
    
    
    init() {
        
    } 
}
extension User{
    
    static func transformUserFromJson(json : [String : Any] , key : String) -> User{
        let user : User = User()
        user.email = json["email"] as? String
        user.profileImageUrl = json["profileImageUrl"] as? String
        user.username = json["username"] as? String
        user.id = key
        return user
    }
    
    
    static func transformUserToJson(user : User) -> [String : Any]{
        var json = [String: Any]()
        json["email"]               = user.email
        json["profileImageUrl"]     = user.profileImageUrl
        json["username"]            = user.username
        json["username_lowercase"]  = user.username?.lowercased()
        return json
    }
    
}
