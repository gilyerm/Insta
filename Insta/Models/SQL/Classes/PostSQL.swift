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
    
    
    static let POST_ID = "Post_ID"; //TEXT PRIMARY KEY
    static let POST_USERID = "Post_UserID"; //TEXT
    static let POST_IMAGE = "Post_Image"; //TEXT
    static let POST_TITLE = "Post_Title"; //TEXT
    
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(POST_ID) TEXT PRIMARY KEY, \(POST_USERID) TEXT, \(POST_IMAGE) TEXT, \(POST_TITLE) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    
    static func addNew(database: OpaquePointer?, data post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(POST_ID), \(POST_USERID), \(POST_IMAGE), \(POST_TITLE)) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let postID = post.postID.cString(using: .utf8)
            let userID = post.userID.cString(using: .utf8)
            let ImageURL = post.ImageURL.absoluteString.cString(using: .utf8)
            let title = post.title.cString(using: .utf8)
            
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