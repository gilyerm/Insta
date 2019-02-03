//
//  UserApi.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase


class UserApi{
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUser(withId uid : String,completion : @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let newuser : User = User.transformUserFromJson(json: dict)
                completion(newuser)
            }
        }
        
    }
}
