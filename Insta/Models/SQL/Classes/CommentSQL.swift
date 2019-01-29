//
//  CommentSQL.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension Comment : SQLiteProtocol{
    
    typealias myType = Comment
    
    static var TableName: String = "Comments"
    
    static let COMMENT_POSTID = "Comment_PostID"; //TEXT
    static let COMMENT_USERID = "Comment_UserID"; //TEXT
    static let COMMENT_FOLLOWED = "Comment_Followed"; //TEXT
    static let COMMENT_TIMESEND = "Comment_TimeSend"; //TEXT // DATE?
    
    static func createTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(COMMENT_POSTID) TEXT, \(COMMENT_USERID) TEXT, \(COMMENT_FOLLOWED) TEXT, \(COMMENT_TIMESEND) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    
    
    static func addNew(database: OpaquePointer?, data: Comment) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(COMMENT_POSTID), \(COMMENT_USERID), \(COMMENT_FOLLOWED), \(COMMENT_TIMESEND)) VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let postID = data.postID.cString(using: .utf8)
            let sender = data.sender.cString(using: .utf8)
            let messsage = data.messsage.cString(using: .utf8)
            let timeSend = data.timeSend.description.cString(using: .utf8)
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, postID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, sender,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, messsage,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, timeSend,-1,nil);
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
    
    static func get(database: OpaquePointer?, byId: String) -> Comment?{
        return nil
    }
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?)->Comment{
        let postID   = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        let sender   = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
        let messsage = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
        let timeSend = Date.date(rfc8601Date: String(cString:sqlite3_column_text(sqlite3_stmt,3)!))
        return Comment(postID: postID, sender: sender, messsage: messsage, timeSend: timeSend!)
    }
    
    
    
}
