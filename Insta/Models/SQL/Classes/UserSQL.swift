//
//  UserSQL.swift
//  Insta
//
//  Created by admin on 27/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

extension User{
    static let USER_TABLE = "USERS";
    static let USER_ID = "USER_ID"; //TEXT PRIMARY KEY
    static let USER_USERNAME = "USER_USERNAME"; //TEXT
    static let USER_EMAIL = "USER_EMAIL"; //TEXT
    static let USER_PROFILEPIC = "USER_PROFILEPIC"; //TEXT
    static let USERS_DETAILS = "USERS_DETAILS"; //TEXT //ARRAY
    
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS \(USER_TABLE) (\(USER_ID) TEXT PRIMARY KEY, \(USER_USERNAME) TEXT, \(USER_EMAIL) TEXT, \(USER_PROFILEPIC) TEXT, \(USERS_DETAILS) TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE \(USER_TABLE);", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[User]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [User]()
        if (sqlite3_prepare_v2(database,"SELECT * from \(USER_TABLE);",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                data.append(getUserByStmt(sqlite3_stmt: sqlite3_stmt))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, user:User){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO \(USER_TABLE)(\(USER_ID), \(USER_USERNAME), \(USER_EMAIL), \(USER_PROFILEPIC), \(USERS_DETAILS)) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let userID = user.userID.cString(using: .utf8)
            let username = user.username.cString(using: .utf8)
            let email = user.email.cString(using: .utf8)
            let profilepic = user.profilepic.cString(using: .utf8)
            
            let details = String(data: (try? JSONSerialization.data(withJSONObject: user.details, options: []))!, encoding: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, userID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, username,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, email,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, profilepic,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, details,-1,nil);
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
        if (sqlite3_prepare_v2(database,"SELECT * from \(USER_TABLE) WHERE \(USER_ID) = ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            
            guard sqlite3_bind_text(sqlite3_stmt, 1, byId,-1,nil) == SQLITE_OK else {
                return nil
            }
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                data = getUserByStmt(sqlite3_stmt: sqlite3_stmt)
            }
        }
        return data;
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: USER_TABLE)
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tabeName: USER_TABLE, date: date);
    }
    
    
    static private func getUserByStmt(sqlite3_stmt: OpaquePointer?)->User{
        let userID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
        let username = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
        let email = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
        let profilepic = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
        let details : String = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
        
        let deailsstst = try? JSONSerialization.jsonObject(with: details.data(using: .utf8)!, options: .mutableLeaves)
    
        return User(userID: userID, username: username, email: email, profilepic: profilepic, details: deailsstst as! [String : String])
    }
}
