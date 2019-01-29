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
    let ref: DatabaseReference!
    lazy var storageRef :StorageReference = Storage.storage().reference()
    lazy var auth : Auth = Auth.auth();
    let userref : DatabaseReference;
    let postref : DatabaseReference;
    let followingref : DatabaseReference;
    let commentref : DatabaseReference;
    let likeref : DatabaseReference;
    let tagref : DatabaseReference;
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        userref = ref.child("users")
        postref = ref.child("posts")
        followingref = ref.child("followings")
        commentref = ref.child("comments")
        likeref = ref.child("likes")
        tagref = ref.child("tags")
    }

}
