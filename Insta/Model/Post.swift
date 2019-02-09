//
//  Post.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post :  Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
    
    var hashValue: Int {
        return (self.id).hashValue
    }
    
    var uid : String?
    var caption : String?
    var photoUrl : String?
    var id : String?
    var likeCount : Int?
    var likes : Dictionary<String,Any>?
    var isliked : Bool?
    
    var createAt :Int?
    
    var lastUpdate : Double?
    
    
}

extension Post{
    
    static func transformPostFromJson(json : [String : Any] , key : String) -> Post{
        let post : Post = Post()
        post.id = key
        post.uid = json["uid"] as? String
        post.caption = json["caption"] as? String
        post.photoUrl = json["photoUrl"] as? String
        post.likeCount = json["likeCount"] as? Int
        post.likes = json["likes"] as? Dictionary<String,Any>
        if let currentUserId = Auth.auth().currentUser?.uid{
            if post.likes != nil {
                post.isliked = (post.likes![currentUserId] != nil)
            }else {
                post.isliked = false
            }
        }else {
            post.isliked = false
        }
        
        post.createAt = json["createAt"] as? Int ?? 0
        post.lastUpdate = json["lastUpdate"] as? Double ?? json["createAt"] as? Double ?? 0
        return post
    }
    
    
    static func transformPostToJson(post : Post) -> [String : Any]{
        var json = [String: Any]()
        json["uid"] = post.uid
        json["caption"] = post.caption
        json["photoUrl"] = post.photoUrl
        json["likeCount"] = post.likeCount ?? 0
        json["likes"] = post.likes
        json["createAt"] = post.createAt ?? 0
        json["lastUpdate"] = post.lastUpdate ?? post.createAt ?? 0
        return json
    }
    
}
