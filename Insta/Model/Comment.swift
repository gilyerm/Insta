//
//  Comment.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

class Comment{
    var uid : String?
    var commentText : String?
    
    init() {
    }
    
    init(uid : String? , commentText : String?) {
        self.uid = uid
        self.commentText = commentText
    }
}

extension Comment{
    
    static func transformCommentFromJson(json : [String : Any]) -> Comment{
        let comment : Comment = Comment()
        comment.uid = json["uid"] as? String
        comment.commentText = json["commentText"] as? String
        return comment
    }
    
    
    static func transformCommentToJson(comment : Comment) -> [String : Any]{
        var json = [String: Any]()
        json["uid"] = comment.uid
        json["commentText"] = comment.commentText
        return json
    }
    
}
