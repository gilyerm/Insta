//
//  JsonProtocol.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import Foundation

protocol JsonProtocol {
    init(json: [String:Any]);
    func toJson() -> [String:Any];
}
