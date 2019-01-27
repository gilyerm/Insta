//
//  FirebasePost.swift
//  Insta
//
//  Created by Gil Yermiyah on 27/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    
    func getAllPostsAndObserve(from:Double, callback:@escaping ([Post])->Void){
        let fbQuery = userref.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Post]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Post(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        postref.observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Post]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Post(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewPost(post:Post){
        postref.child(post.postID).setValue(post.toJson())
    }
    
    func getPost(byId:String)->Post?{
        return postref.value(forKey: byId) as! Post?
    }
}
