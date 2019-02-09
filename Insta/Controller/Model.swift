//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import UIKit

class Model {
    static let instance:Model = Model()


    var modelSql = ModelSql();
    //var modelFirebase = ModelFirebase();

    private init(){
    }



    func getAllPostsUsers(currentUserid : String) {
        print("getAllPostsUsers")
        
        //1. read local users last update date
        var lastUpdated = Post.getLastUpdateDate(database: modelSql.database)
        lastUpdated += 1;
        
        //2. get updates from firebase and observe
        
        Api.Feed.observeFeeds(withId: currentUserid) { (posts: [Post]) in
            //3. write new records to the local DB
            for post in posts {
                Post.addNew(database: self.modelSql.database, data: post)
                if (post.lastUpdate != nil && Double(post.lastUpdate!) > lastUpdated){
                    lastUpdated = Double(post.lastUpdate!)
                }
            }
            
            //4. update the local users last update date
            Post.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
            
            //5. get the full data
            let stFullData = Post.getAll(database: self.modelSql.database)

            var postUsers : [Post:User] = [Post:User]()
            
            self.getAllUsers(callback: { (users : [User]) in
                print("users \(users)")
                for p in stFullData {
                    let user = users.first(where: { (user:User) -> Bool in
                        return p.uid == user.id
                    })
                    postUsers.updateValue(user!, forKey: p)
                }
                //6. notify observers with full data
                ModelNotification.userPostsListNotification.notify(data: postUsers)
            })
        }
    }

    func getAllUsers(callback:@escaping ([User])->Void){
        
        //1. read local users last update date
        var lastUpdated = User.getLastUpdateDate(database: modelSql.database)
        //lastUpdated += 1;
        
        //2. get updates from firebase and observe
        Api.User.observeCurrentUser { (curUser: User) in
            Api.Follow.getAllFollowings(userId: curUser.id!) { (users: [User]) in
                var users1 = users
                users1.append(curUser)
                //3. write new records to the local DB
                print("users1 \(users1)")
                users1.forEach({ (user: User) in
                    User.addNew(database: self.modelSql.database, data: user)
                    if (user.lastUpdate != nil && Double(user.lastUpdate!) > lastUpdated) {
                        lastUpdated = user.lastUpdate!
                    }
                })
                
                //4. update the local users last update date
                User.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
                
                //5. get the full data
                let stFullData = User.getAll(database: self.modelSql.database)
                
                callback(stFullData)
            }
        }
        
    }
    
    
    func followUser(user : User){
        Api.Follow.followAction(withUser: user.id!)
        User.addNew(database: modelSql.database, data: user)
        
        Api.UserPosts.fechUserPosts(userId: user.id!) { (postId: String) in
            Api.Post.observePost(withId: postId, completion: { (post:Post) in
                Post.addNew(database: self.modelSql.database, data: post)
            })
        }
        
    }
    func unfollowUser(user : User){
        Api.Follow.unFollowAction(withUser: user.id!)
        User.delete(database: modelSql.database, byId: user.id!)
        
        Api.UserPosts.fechUserPosts(userId: user.id!) { (postId: String) in
            Api.Post.observePost(withId: postId, completion: { (post:Post) in
                Post.delete(database: self.modelSql.database, byId: post.id!)
            })
        }
    }
    
    
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            //2. get the image from Firebase
            HelperService.getImage(url: url){(image:UIImage?) in
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
    
    
    func clearCache(){
        var url = getDocumentsDirectory()
        url.removeAllCachedResourceValues()
    }
}
