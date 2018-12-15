//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation

class Model {
    static let instance:Model = Model()


    //var modelSql:ModelSql?
    var modelFirebase = ModelFirebase();

    private init(){
        //modelSql = ModelSql()
    }



    func getAllStudents() {
        modelFirebase.getAllStudents(callback: {(data:[Student]) in
            ModelNotification.studentsListNotification.notify(data: data)

        })
    }

    func getAllStudents(callback:@escaping ([Student])->Void){
        modelFirebase.getAllStudents(callback: callback);
        //return Student.getAll(database: modelSql!.database);
    }

    func addNewStudent(student:Student){
        modelFirebase.addNewStudent(student: student);
        //Student.addNew(database: modelSql!.database, student: student)
    }

    func getStudent(byId:String)->Student?{
        return modelFirebase.getStudent(byId:byId)
        //return Student.get(database: modelSql!.database, byId: byId);
    }



    func saveImage(image:UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
    }

    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        modelFirebase.getImage(url: url, callback: callback)
    }
}
