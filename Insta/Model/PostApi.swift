//
//  PostApi.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase


class PostApi{
    var REF_POSTS = Database.database().reference().child("posts")
 
    
    func observePosts(completion : @escaping (Post) -> Void){
        REF_POSTS.observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let newpost : Post = Post.transformPostFromJson(json: dict , key: snapshot.key)
                completion(newpost)
            }
        }
    }    
}
