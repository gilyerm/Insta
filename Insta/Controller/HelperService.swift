//
//  HelperService.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import Firebase
import ProgressHUD

class HelperService {
    static func uploadDataToServer(data: Data, caption: String, onSuccess: @escaping () -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = url?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!, caption: caption, onSuccess: onSuccess)
            })
            
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, caption: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        
        let post:Post = Post()
        post.uid = currentUserId
        post.photoUrl = photoUrl
        post.caption = caption
        let timestamp = Int(Date().timeIntervalSince1970)
        post.createAt = timestamp
        post.lastUpdate = Double(timestamp)
        newPostReference.setValue(Post.transformPostToJson(post: post), withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId!).setValue(true)
            
            let myPostRef = Api.UserPosts.REF_USER_POSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                Api.Follow.REF_FOLLOWERS.child(currentUserId).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                    print("users snapshot \(snapshot)")
                    let arrSnapshot = (snapshot.children.allObjects as! [DataSnapshot])
                    for child in arrSnapshot {
                        Api.Feed.REF_FEED.child(child.key).child(newPostId!).setValue(true)
                    }
                })
                
            })
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
    
    static func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
}
