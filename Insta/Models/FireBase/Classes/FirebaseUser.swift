//
//  FirebaseUser.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    
    func getAllUsersAndObserve(from:Double, callback:@escaping ([User])->Void){
        let fbQuery = userref.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [User]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(User(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    
    
    func getAllUsers(callback:@escaping ([User])->Void){
        userref.observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [User]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(User(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewUser(user:User){
        userref.child(user.userID).setValue(user.toJson())
    }
//
//    func getUser(byId:String)->User?{
//        return userref.value(forKey: byId) as! User?
//    }
//
    func getUsers(byId : String,callback:@escaping ([User])->Void){
        commentref.queryEqual(toValue: byId).observeSingleEvent(of:.value, with: {
            (snapshot) in
            // Get user value
            var data = [User]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(User(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
}
