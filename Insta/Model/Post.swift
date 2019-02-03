//
//  Post.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class Post{
    var uid : String?
    var caption : String?
    var photoUrl : String?
    var id : String?
    
    
    init(uid : String,captionText : String , photoUrlString : String ) {
        self.uid = uid
        self.caption = captionText
        self.photoUrl = photoUrlString
    }
    
    init() {
        
    }
}

extension Post{
    
    static func transformPostFromJson(json : [String : Any] , key : String) -> Post{
        let post : Post = Post()
        post.id = key
        post.uid = json["uid"] as? String
        post.caption = json["caption"] as? String
        post.photoUrl = json["photoUrl"] as? String
        return post
    }
    
    
    static func transformPostToJson(post : Post) -> [String : Any]{
        var json = [String: Any]()
        json["uid"] = post.uid
        json["caption"] = post.caption
        json["photoUrl"] = post.photoUrl
        return json
    }
    
}
