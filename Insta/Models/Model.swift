//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import UIKit

class Model {
    static let instance:Model = Model()


    //var modelSql:ModelSql?
    var modelFirebase = ModelFirebase();

    private init(){
        //modelSql = ModelSql()
    }



    func getAllUsers() {
        modelFirebase.getAllUsers(callback: {(data:[User]) in
            ModelNotification.userListNotification.notify(data: data)
        })
    }

    func getAllUsers(callback:@escaping ([User])->Void){
        modelFirebase.getAllUsers(callback: callback);
        //return Student.getAll(database: modelSql!.database);
    }

    func addNewUser(user:User){
        modelFirebase.addNewUser(user: user);
        //Student.addNew(database: modelSql!.database, student: student)
    }

    func getUser(byId:String)->User?{
        return modelFirebase.getUser(byId:byId)
        //return Student.get(database: modelSql!.database, byId: byId);
    }



    func saveImage(image:UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
    }

    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        modelFirebase.getImage(url: url, callback: callback)
    }
}
