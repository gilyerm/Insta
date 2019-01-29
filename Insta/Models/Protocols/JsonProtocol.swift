//
//  JsonProtocol.swift
//  Insta
//
//  Created by admin on 10/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

protocol JsonProtocol {
    init(json: [String:Any]);
    func toJson() -> [String:Any];
}
