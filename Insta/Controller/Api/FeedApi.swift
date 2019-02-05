
//
//  FeedApi.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    let REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(withId id:String , completion : @escaping (Post) -> Void){
        REF_FEED.child(id).observe(.childAdded) { (snapshot: DataSnapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post: Post) in
                completion(post)
            })
        }
    }
    
    func observeFeedRemove(withId id:String, completion : @escaping (Post) -> Void){
        REF_FEED.child(id).observe(.childRemoved) { (snapshot: DataSnapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post: Post) in
                completion(post)
            })
            
        }
    }
}
