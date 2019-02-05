//
//  CommentApi.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    var REF_COMMENTS = Database.database().reference().child("comments")
    
    func observeComments(withPostId id : String , completion : @escaping (Comment) -> Void){
        REF_COMMENTS.child(id).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let dict : [String : Any] = snapshot.value as? [String : Any] {
                let comment :Comment = Comment.transformCommentFromJson(json: dict)
                completion(comment)
            }
            
        }
    }
}
