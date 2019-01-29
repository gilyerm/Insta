//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import Firebase

extension ModelFirebase {
    func saveImage(image:UIImage, name:(String),
                   callback:@escaping (String?)->Void){
        let data = image.jpegData(compressionQuality: 0.8) //new version
        //let data = UIImageJPEGRepresentation(image,0.8) //old version
        let imageRef = storageRef.child(name)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }

    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
}
