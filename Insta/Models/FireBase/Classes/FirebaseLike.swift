//
//  FirebaseLike.swift
//  Insta
//
//  Created by gil yermiyah on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    
    func getAllLikesAndObserve(from:Double, callback:@escaping ([Like])->Void){
        let fbQuery = likeref.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Like]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Like(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    
    
    func getAllLikes(callback:@escaping ([Like])->Void){
        likeref.observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Like]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Like(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewLike(like:Like){
        likeref.child(like.postID).setValue(like.toJson())
    }
    
    func getLike(byId:String)->Like?{
        return likeref.value(forKey: byId) as! Like?
    }
}
