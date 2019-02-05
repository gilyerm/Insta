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
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void){
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {snapshot in
        if let dict = snapshot.value as? [String: Any] {
            let post = Post.transformPostFromJson(json: dict, key: snapshot.key)
            completion(post)
            }
        })
    }
    
    func observeLikeCount(withPostId id : String , completion: @escaping (Int) -> Void) {
        Api.Post.REF_POSTS.child(id).observe(.childChanged) { (snapshot :DataSnapshot) in
            if let count = snapshot.value as? Int {
                completion(count)
            }
        }
    }
    
    func incrementLikes(postId : String , onSucess: @escaping (Post) -> Void , onError  : @escaping (_ errorMsg : String?) -> Void){
        let ref = Api.Post.REF_POSTS.child(postId)
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.CURRENT_USER?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unslike the post and remove self from likes
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount  as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any]{
                let post = Post.transformPostFromJson(json: dict, key: snapshot!.key)
                onSucess(post)
            }
        }
    }
}
