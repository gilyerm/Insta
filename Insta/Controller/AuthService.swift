//
//  AuthService.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
        
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult :AuthDataResult?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = authDataResult?.user.uid
            let storageRef = Storage.storage().reference().child("profile_image").child(uid!)

            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (url :URL?, error :Error?) in
                    if error != nil {
                        onError(error!.localizedDescription)
                        return
                    }
                    self.setUserInfomation(profileImageUrl: url!.absoluteString, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                })
            })
        }
    }
    
    static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let usersReference = Api.User.REF_USERS
        let newUserReference = usersReference.child(uid)
        let user: User = User()
        user.username = username
        user.email = email
        user.profileImageUrl = profileImageUrl
        newUserReference.setValue(User.transformUserToJson(user: user))
        onSuccess()
    }
    
    static func updateUserInfo(username: String, email: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void){
        
        Api.User.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            else {
                let uid = Api.User.CURRENT_USER?.uid
                let storageRef = Storage.storage().reference().child("profile_image").child(uid!)
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (url :URL?, error :Error?) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                        self.updateDatabase(username: username, email: email, profileImageUrl: url!.absoluteString, onSuccess: onSuccess, onError: onError)
                    })
                })
            }
        })
        
    }
    
    static func updateDatabase(username: String, email: String, profileImageUrl: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void){
        let user: User = User()
        user.username = username
        user.email = email
        user.profileImageUrl = profileImageUrl
        Api.User.RefCurrentUser?.updateChildValues(User.transformUserToJson(user: user), withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            } else {
                onSuccess()
            }
        })
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
    
    
    
    
}
