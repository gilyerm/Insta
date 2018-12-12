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
    
    init(postID : String,userID : String,ImageURL : URL,title : String,likes : [String],commonts : [Comment],tags : [String]) {
        self.postID=postID;
        self.userID=userID;
        self.ImageURL=ImageURL;
        self.title=title;
        self.likes=likes;
        self.commonts=commonts;
        self.tags=tags;
    }
    
}
