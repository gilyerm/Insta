//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

class ModelNotification {
    static let userListNotification = MyNotification<[User]>("com.insta.userlist")
    
    static let userPostsListNotification = MyNotification<[Post:User]>("com.insta.userPostsList")

    class MyNotification<T> {
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
    }
}


