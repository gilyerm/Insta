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
    var ref: DatabaseReference!
    lazy var storageRef :StorageReference = Storage.storage().reference()
    lazy var auth : Auth = Auth.auth();
    var userref : DatabaseReference;
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        userref = ref.child("users")

    }

}
