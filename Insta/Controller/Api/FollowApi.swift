//
//  FollowApi.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    
    func followAction(withUser id: String){
        Api.UserPosts.REF_USER_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any]{
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        }
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String){
        Api.UserPosts.REF_USER_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any]{
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        }
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).removeValue()
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).removeValue()
    }
    
    func isFollowing(userId : String, completed : @escaping (Bool)->Void){
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else{
                completed(true)
            }
        }
    }
    
    
    func fechCountFollowing(userId : String, completion : @escaping (Int)->Void) {
        REF_FOLLOWING.child(userId).observe(.value) { (snapshot: DataSnapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func fechCountFollowers(userId : String, completion : @escaping (Int)->Void) {
        REF_FOLLOWERS.child(userId).observe(.value) { (snapshot: DataSnapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
    
}
