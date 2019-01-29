//
//  FollowingSQL.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

extension Following : SQLiteProtocol{
    typealias myType = Following
    
    static var TableName: String = "Followings"
    
    static let FOLLOWING_USERID = "Following_UserID"; //TEXT PRIMARY KEY
    static let FOLLOWING_FOLLOWED = "Following_Followed"; //TEXT //ARRAY
    
    static func createTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(FOLLOWING_USERID) TEXT PRIMARY KEY, \(FOLLOWING_FOLLOWED) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addNew(database: OpaquePointer?, data following: Following) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(FOLLOWING_USERID), \(FOLLOWING_FOLLOWED)) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let userID = following.userID.cString(using: .utf8)
            let followed = String(data: (try? JSONSerialization.data(withJSONObject: following.followed, options: []))!, encoding: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, userID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, followed,-1,nil);
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
    
    static func get(database: OpaquePointer?, byId: String) -> Following? {
        var sqlite3_stmt: OpaquePointer? = nil
        var data :Following? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from \(TableName) WHERE \(FOLLOWING_USERID) = ?;",-1,&sqlite3_stmt,nil)
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
    
    
    
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?)->Following{
        let userID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        let followed = try? JSONSerialization.jsonObject(with: String(cString:sqlite3_column_text(sqlite3_stmt,1)!).data(using: .utf8)!, options: .mutableLeaves)
        return Following(userID: userID, followed: followed as! [String])
    }
    
}
