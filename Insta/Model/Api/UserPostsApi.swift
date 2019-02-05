//
//  UserPostsApi.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPostsApi {
    var REF_USER_POSTS = Database.database().reference().child("userPosts")
    
}
