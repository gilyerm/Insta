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
            //dropTables()
            createTables()
        }
        
    }
    
    func createTables() {
        User.createTable(database: database);
        LastUpdateDates.createTable(database: database);
    }
    
    func dropTables(){
        User.drop(database: database)
        LastUpdateDates.drop(database: database)
    }
    
    
}
