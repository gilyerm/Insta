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
            let likeCount   = String(post.likeCount ?? 0).cString(using: .utf8)
            var likes = ""
            if post.likeCount ?? 0 > 0 {
                likes = String(data: (try? JSONSerialization.data(withJSONObject: post.likes!, options: []))!, encoding: .utf8)!
            }
            let isliked     = String(post.isliked ?? false).cString(using: .utf8)
            let createAt    = String(post.createAt ?? 0).cString(using: .utf8)
            
//            let commonts = String(data: (try? JSONSerialization.data(withJSONObject: post.commonts, options: []))!, encoding: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id       ,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, uid      ,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, caption  ,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, photoUrl ,-1,nil);
            sqlite3_bind_text (sqlite3_stmt, 5,likeCount,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, likes    ,-1,nil);
            sqlite3_bind_text (sqlite3_stmt, 7, isliked ,-1,nil);
            sqlite3_bind_text (sqlite3_stmt, 8,createAt ,-1,nil);
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
        if (sqlite3_prepare_v2(database,"SELECT * from \(TableName) WHERE \(post_id) = ?;",-1,&sqlite3_stmt,nil)
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
    
    
    static func delete(database: OpaquePointer?, byId:String)->Void{
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE from \(TableName) WHERE \(post_id) = ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            
            guard sqlite3_bind_text(sqlite3_stmt, 1, byId,-1,nil) == SQLITE_OK else {
                return
            }
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("Successfully deleted row.")
                return
            } else {
                print("could not delete row.")
                return
            }
        }
        print("Delete stattement could not be prepared.")
    }
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?)->Post{
        let post :Post = Post()

        post.id         = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        post.uid        = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
        post.caption    = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
        post.photoUrl   = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
        post.likeCount  = Int(String(cString:sqlite3_column_text(sqlite3_stmt,4)!))
        post.likes      = try? JSONSerialization.jsonObject(with: String(cString:sqlite3_column_text(sqlite3_stmt,5)!).data(using: .utf8)!, options: .mutableLeaves) as! Dictionary<String, Any>
        post.isliked    = Bool(String(cString:sqlite3_column_text(sqlite3_stmt,6)!))
        post.createAt   = Int(String(cString:sqlite3_column_text(sqlite3_stmt,7)!))
        
        
        //let commont = try? JSONSerialization.jsonObject(with: String(cString:sqlite3_column_text(sqlite3_stmt,4)!).data(using: .utf8)!, options: .mutableLeaves)
        return post
    }
    
}
