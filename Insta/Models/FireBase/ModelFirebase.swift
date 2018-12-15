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

class ModelFirebase{
    var ref: DatabaseReference!
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()

    }

}
