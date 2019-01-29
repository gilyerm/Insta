//
//  FirebaseTag.swift
//  Insta
//
//  Created by gil yermiyah on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    
    func getAllTagsAndObserve(from:Double, callback:@escaping ([Tag])->Void){
        let fbQuery = tagref.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Tag]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Tag(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    
    
    func getAllUsers(callback:@escaping ([Tag])->Void){
        tagref.observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Tag]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Tag(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewUser(tag:Tag){
        tagref.child(tag.postID).setValue(tag.toJson())
    }
    
    func getUser(byId:String)->Tag?{
        return tagref.value(forKey: byId) as! Tag?
    }
}
