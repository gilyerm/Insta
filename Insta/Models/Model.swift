//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import UIKit

class Model {
    static let instance:Model = Model()


    var modelSql = ModelSql();
    var modelFirebase = ModelFirebase();

    private init(){
    }



    func getAllUsers() {
        //1. read local users last update date
        var lastUpdated = User.getLastUpdateDate(database: modelSql.database)
        lastUpdated += 1;
        
        //2. get updates from firebase and observe
        modelFirebase.getAllUsersAndObserve(from:lastUpdated){ (data:[User]) in
            //3. write new records to the local DB
            for us in data{
                User.addNew(database: self.modelSql.database, user: us)
                if (us.lastUpdate != nil && us.lastUpdate! > lastUpdated){
                    lastUpdated = us.lastUpdate!
                }
            }
            
            //4. update the local users last update date
            User.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
            
            //5. get the full data
            let stFullData = User.getAll(database: self.modelSql.database)
            
            //6. notify observers with full data
            ModelNotification.userListNotification.notify(data: stFullData)
        }
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
