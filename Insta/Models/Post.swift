//
//  Post.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var postID : String;
    var userID : String;
    var ImageURL : URL;
    var title : String;
    var likes : [String]; // collection of user ids
    var commonts : [Comment];
    var tags : [String]; // collection of user ids
    
    
}
