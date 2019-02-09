//
//  UserSQL.swift
//  Insta
//
//  Created by admin on 27/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

extension User : SQLiteProtocol{
    typealias myType = User
    
    static var TableName: String = "Users";
    
    static let user_id = "user_id"
    static let user_username = "user_username"
    static let user_email = "user_email"
    static let user_profileImageUrl = "user_profileImageUrl"
    static let user_isFollowing = "user_isFollowing"
    
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(TableName) (\(user_id) TEXT PRIMARY KEY, \(user_username) TEXT, \(user_email) TEXT, \(user_profileImageUrl) TEXT, \(user_isFollowing) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addNew(database: OpaquePointer?, data user:User){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(TableName)(\(user_id), \(user_username), \(user_email), \(user_profileImageUrl), \(user_isFollowing)) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            print("user \(user)")
            let userID = user.id?.cString(using: .utf8)
            let username = user.username?.cString(using: .utf8)
            let email = user.email?.cString(using: .utf8)
            let profilepic = user.profileImageUrl?.cString(using: .utf8)
            let isFollowing = String(user.isFollowing ?? false).cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, userID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, username,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, email,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, profilepic,-1,nil);
            sqlite3_bind_text (sqlite3_stmt, 5, isFollowing,-1,nil);
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
    
    
    static func get(database: OpaquePointer?, byId:String)->User?{
        var sqlite3_stmt: OpaquePointer? = nil
        var data :User? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from \(TableName) WHERE \(user_id) = ?;",-1,&sqlite3_stmt,nil)
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
        if (sqlite3_prepare_v2(database,"DELETE from \(TableName) WHERE \(user_id) = ?;",-1,&sqlite3_stmt,nil)
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
    
    
    static func getTypeByStmt(sqlite3_stmt: OpaquePointer?)->User{
        let user: User = User()
        user.id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        user.username = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
        user.email = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
        user.profileImageUrl = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
        user.isFollowing = String(cString:sqlite3_column_text(sqlite3_stmt,4)!) != String(false)
    
        return user
    }
}
