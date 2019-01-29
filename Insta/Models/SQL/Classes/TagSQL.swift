//
//  TagSQL.swift
//  Insta
//
//  Created by gil yermiyah on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension Tag : SQLiteProtocol{
    typealias myType = Tag
    
    static var TableName: String = "Tags"
    
    static let TAGS_POSTID = "Tag_PostID"; //TEXT PRIMARY KEY
    static let TAGS_TAGS = "Tag_Tags"; //TEXT //ARRAY
    
    static func createTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(TAGS_POSTID) TEXT PRIMARY KEY, \(TAGS_TAGS) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addNew(database: OpaquePointer?, data tag: Tag) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(TAGS_POSTID), \(TAGS_TAGS)) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let postID = tag.postID.cString(using: .utf8)
            let tags = String(data: (try? JSONSerialization.data(withJSONObject: tag.tags, options: []))!, encoding: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, postID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, tags,-1,nil);
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
    
    static func get(database: OpaquePointer?, byId: String) -> Tag? {
        var sqlite3_stmt: OpaquePointer? = nil
        var data :Tag? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from \(TableName) WHERE \(TAGS_POSTID) = ?;",-1,&sqlite3_stmt,nil)
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
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?) -> Tag {
        let postID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        let tags = try? JSONSerialization.jsonObject(with: String(cString:sqlite3_column_text(sqlite3_stmt,1)!).data(using: .utf8)!, options: .mutableLeaves)
        return Tag(postID: postID, tags: tags as! [String])
    }
}
