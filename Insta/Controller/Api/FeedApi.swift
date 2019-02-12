
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
        REF_FEED.child(id).queryOrdered(byChild: "createAt").observe(.childAdded) { (snapshot: DataSnapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post: Post) in
                completion(post)
            })
        }
    }
    
    
    func observeFeeds(withId id:String , completion : @escaping ([Post]) -> Void){
        REF_FEED.child(id).queryOrdered(byChild: "createAt").observe(.value) { (snapshot: DataSnapshot) in
            print("snapshot: \(snapshot)")
            let arrSnapshot = (snapshot.children.allObjects as! [DataSnapshot])
            Api.Post.observePosts(completion: { (posts: [Post]) in
                var postsids = [String]()
                arrSnapshot.forEach({ (child :DataSnapshot) in
                    let postid =  child.key
                    postsids.append(postid)
                })
                let posts = posts.filter({ (post:Post) -> Bool in
                    return postsids.contains(where: { (id :String) -> Bool in
                        return post.id == id
                    })
                })
                completion(posts)
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
