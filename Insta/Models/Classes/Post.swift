//
//  Post.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class Post: NSObject,JsonProtocol {
    var postID : String;
    var userID : String;
    var ImageURL : URL;
    var title : String;
    
    init(postID : String,userID : String,ImageURL : URL,title : String) {
        self.postID=postID;
        self.userID=userID;
        self.ImageURL=ImageURL;
        self.title=title;
    }
    
    
    required init(json: [String : Any]) {
        self.postID = json["postID"] as! String;
        self.userID = json["userID"] as! String;
        self.ImageURL = json["ImageURL"] as! URL;
        self.title = json["title"] as! String;
//        self.commonts = [Comment]()
//        if(json["commonts"] != nil){
//            let cms = json["commonts"] as! [[String:Any]]
//            for cm in cms{
//                self.commonts.append(Comment(json: cm))
//            }
//        }
    }
    
    func toJson() -> [String : Any] {
        var json = [String:Any]()
        json["postID"] = postID
        json["userID"] = userID
        json["ImageURL"] = ImageURL
        json["title"] = title
        
//        var cms = [[String:Any]]();
//        for cm in commonts {
//            cms.append(cm.toJson())
//        }
//        json["commonts"] = cms
        return json
    }
    
}
