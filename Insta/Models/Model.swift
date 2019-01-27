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
        //modelFirebase.getImage(url: url, callback: callback)
        
        //1. try to get the image from local store
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            //2. get the image from Firebase
            modelFirebase.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
                print("got image from firebase \(localImageName)")
            }
        }
    }
    
    /// File handling
    func saveImageToFile(image:UIImage, name:String){
        
//        if let data = UIImageJPEGRepresentation(image, 0.8) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
}
