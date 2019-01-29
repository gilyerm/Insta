//
//  ModelFirebase.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import UIKit

class ModelFirebase{
    static let ref: DatabaseReference! = Database.database().reference()
    static var storageRef :StorageReference = Storage.storage().reference()
    static var auth : Auth = Auth.auth();
    static let userref : DatabaseReference = ref.child("users")
    static let postref : DatabaseReference = ref.child("posts")
    static let followingref : DatabaseReference = ref.child("followings")
    static let commentref : DatabaseReference = ref.child("comments")
    static let likeref : DatabaseReference = ref.child("likes")
    static let tagref : DatabaseReference = ref.child("tags")
    
    init() {
        FirebaseApp.configure()
    }

}
