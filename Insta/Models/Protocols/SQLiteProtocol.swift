//
//  SQLiteProtocol.swift
//  Insta
//
//  Created by gil yermiyah on 28/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

protocol SQLiteProtocol {
    associatedtype myType
    static func createTable(database: OpaquePointer?)
    static func drop(database: OpaquePointer?)
    static func getAll(database: OpaquePointer?)->[myType]
    static func addNew(database: OpaquePointer?, data:myType)
    static func get(database: OpaquePointer?, byId:String)->myType?
    static func getLastUpdateDate(database: OpaquePointer?)->Double
    static func setLastUpdateDate(database: OpaquePointer?, date:Double)
}
