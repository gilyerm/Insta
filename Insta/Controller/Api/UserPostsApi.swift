//
//  UserPostsApi.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPostsApi {
    var REF_USER_POSTS = Database.database().reference().child("userPosts")
    
    
    func fechUserPosts(userId : String, completion : @escaping (String)->Void) {
        REF_USER_POSTS.child(userId).observe(.childAdded) { (snapshot: DataSnapshot) in
            completion(snapshot.key)
        }
    }
    
    func fechCountUserPosts(userId : String, completion : @escaping (Int)->Void) {
        REF_USER_POSTS.child(userId).observe(.value) { (snapshot: DataSnapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
    
}
