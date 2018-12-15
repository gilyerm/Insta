//
//  FirebaseUser.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

extension ModelFirebase{
    func getAllUsers(callback:@escaping ([User])->Void){
        ref.child("users").observe(.value, with: {
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
        ref.child("users").child(user.userID).setValue(user.toJson())
    }
    
    func getUser(byId:String)->User?{
        return ref.child("users").value(forKey: byId) as User?
    }
}
