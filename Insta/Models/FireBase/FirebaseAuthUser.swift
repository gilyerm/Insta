//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import Firebase

extension ModelFirebase {
    
    static func signin(email:String, password:String, callback:@escaping (Bool)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (user != nil){
                //user?.user.uid
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
    static func createUser(email:String, password:String, callback:@escaping (Bool)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if authResult?.user != nil {
                callback (true)
            }else{
                callback (false)
            }
        }
    }
    
    static func checkIfSignIn() -> Bool {
        return (Auth.auth().currentUser != nil)
    }
    
    static func getUser()->Firebase.User?{
        return Auth.auth().currentUser
    }
}
