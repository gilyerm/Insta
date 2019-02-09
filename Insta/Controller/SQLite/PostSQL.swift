//
//  PostSQL.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension Post : SQLiteProtocol{
    
    typealias myType = Post
    
    static var TableName: String = "Posts";
    
    static let post_id = "post_id"
    static let post_uid = "post_uid"
    static let post_caption = "post_caption"
    static let post_photoUrl = "post_photoUrl"
    static let post_likeCount = "post_likeCount"
    static let post_likes = "post_likes"
    static let post_isliked = "post_isliked"
    static let post_createAt = "post_createAt"
    
    
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(post_id) TEXT PRIMARY KEY, \(post_uid) TEXT, \(post_caption) TEXT, \(post_photoUrl) TEXT, \(post_likeCount) TEXT, \(post_likes) TEXT, \(post_isliked) TEXT, \(post_createAt) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    
    static func addNew(database: OpaquePointer?, data post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(post_id), \(post_uid), \(post_caption), \(post_photoUrl), \(post_likeCount), \(post_likes), \(post_isliked), \(post_createAt)) VALUES (?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id          = post.id?.cString(using: .utf8)
            let uid         = post.uid?.cString(using: .utf8)
            let caption     = post.caption?.cString(using: .utf8)
            let photoUrl    = post.photoUrl?.cString(using: .utf8)
            let likeCount   = post.likeCount?
            let likes       = post.likes.cString(using: .utf8)
            let isliked     = post.isliked.cString(using: .utf8)
            let createAt    = post.createAt.cString(using: .utf8)
            
//            let commonts = String(data: (try? JSONSerialization.data(withJSONObject: post.commonts, options: []))!, encoding: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, postID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, ImageURL,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, title,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->Post?{
        var sqlite3_stmt: OpaquePointer? = nil
        var data :Post? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from \(TableName) WHERE \(POST_ID) = ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            
            guard sqlite3_bind_text(sqlite3_stmt, 1, byId,-1,nil) == SQLITE_OK else {
                return nil
            }
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                data = getTypeByStmt(sqlite3_stmt: sqlite3_stmt)
            }
        }
        return data;
    }
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?)->Post{
        let postID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        let userID  = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
        let ImageURL = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
        let title  = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)

//        let commont = try? JSONSerialization.jsonObject(with: String(cString:sqlite3_column_text(sqlite3_stmt,4)!).data(using: .utf8)!, options: .mutableLeaves)
        
        
        return Post(postID: postID, userID: userID, ImageURL: URL.init(fileURLWithPath: ImageURL), title: title)
    }
    
}
