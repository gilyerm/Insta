//
//  FirebaseFollowing.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    
    func getAllFollowingsAndObserve(from:Double, callback:@escaping ([Following])->Void){
        let fbQuery = followingref.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Following]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Following(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    
    
    func getAllFollowings(callback:@escaping ([Following])->Void){
        followingref.observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Following]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Following(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewFollowing(following:Following){
        followingref.child(following.userID).setValue(following.toJson())
    }
    
    func getFollowing(byId:String)->Following?{
        return followingref.value(forKey: byId) as! Following?
    }
}
