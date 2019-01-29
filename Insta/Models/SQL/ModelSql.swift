//
//  ModelSql.swift
//  Insta
//
//  Created by admin on 27/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

class ModelSql {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "databaseInsta.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            dropTables()
            createTables()
        }
        
    }
    
    func createTables() {
        Comment.createTable(database: database)
        Following.createTable(database: database)
        Like.createTable(database: database)
        Post.createTable(database: database)
        Tag.createTable(database: database)
        User.createTable(database: database)
        LastUpdateDates.createTable(database: database);
    }
    
    func dropTables(){
        Comment.drop(database: database)
        Following.drop(database: database)
        Like.drop(database: database)
        Post.drop(database: database)
        Tag.drop(database: database)
        User.drop(database: database)
        LastUpdateDates.drop(database: database)
    }
    
    
}
