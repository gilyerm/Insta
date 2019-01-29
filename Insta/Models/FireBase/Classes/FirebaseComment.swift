//
//  FirebaseComment.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    
    func getAllCommentsAndObserve(from:Double, callback:@escaping ([Comment])->Void){
        let fbQuery = commentref.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Comment]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Comment(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    func getAllComments(callback:@escaping ([Comment])->Void){
        commentref.observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Comment]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Comment(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewComment(comment:Comment){
        commentref.child(comment.postID).childByAutoId().setValue(comment.toJson())
    }
    
    func getComments(postID : String,callback:@escaping ([Comment])->Void){
        commentref.queryEqual(toValue: postID).observeSingleEvent(of:.value, with: {
            (snapshot) in
            // Get user value
            var data = [Comment]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Comment(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
}
