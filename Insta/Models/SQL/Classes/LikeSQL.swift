//
//  LikeSQL.swift
//  Insta
//
//  Created by gil yermiyah on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension Like :SQLiteProtocol{
    typealias myType = Like
    
    static var TableName: String = "Likes"
    
    static let Like_PostID = "Like_PostID"; //TEXT PRIMARY KEY
    static let Like_USERID = "Like_UserID"; //TEXT // ARRAY
    
    static func createTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(Like_PostID) TEXT PRIMARY KEY, \(Like_USERID) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addNew(database: OpaquePointer?, data like: Like) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(Like_PostID), \(Like_USERID)) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let postID = like.postID.cString(using: .utf8)
            let likers = String(data: (try? JSONSerialization.data(withJSONObject: like.likers, options: []))!, encoding: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, postID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, likers,-1,nil);
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
    
    static func get(database: OpaquePointer?, byId: String) -> Like? {
        var sqlite3_stmt: OpaquePointer? = nil
        var data :Like? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from \(TableName) WHERE \(Like_PostID) = ?;",-1,&sqlite3_stmt,nil)
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
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?) -> Like {
        let postID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        let likers = try? JSONSerialization.jsonObject(with: String(cString:sqlite3_column_text(sqlite3_stmt,1)!).data(using: .utf8)!, options: .mutableLeaves)
        return Like(postID: postID, likers: likers as! [String])
    }
    
    
    
    
}
