//
//  MyDate.swift
//  Insta
//
//  Created by Gil Yermiyah on 19/12/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import Foundation


////https://dzone.com/articles/all-you-need-to-know-about-json-with-swift

extension Date {
    // expects a dictionary containing:
    //    "format": "longStyle",
    //    "date": "June 2, 2014"
    static func date(dictionary: [String: Any]?) -> Date? {
        if let format = dictionary?["format"] as? String,
            let date = dictionary?["date"] as? String {
            if format == "longStyle" {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                return formatter.date(from: date)
            }
        }
        return nil
    }
    //expects a string like: 2016-12-05
    static func date(yyyyMMdd: String?) -> Date? {
        if let string = yyyyMMdd {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: string)
        }
        return nil
    }
    // The date format specified in the RFC 8601 standard
    // is common place on internet communication
    // expects a string as: 2017-01-17T20:15:00+0100
    static func date(rfc8601Date: String?) -> Date? {
        if let string = rfc8601Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return formatter.date(from: string)
        }
        return nil
    }
}
