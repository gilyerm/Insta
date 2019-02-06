//
//  PeopleVC.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class PeopleVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    
    func loadUsers(){
        self.users.removeAll()
        self.tableView.reloadData()
        Api.User.observeUsers { (user: User) in
            if Api.User.CURRENT_USER!.uid != user.id{
                self.isFollowing(userId: user.id!, completed: { (isfollowing:Bool) in
                    user.isFollowing = isfollowing
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func isFollowing(userId : String , completed : @escaping (Bool)->Void){
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue"{
            let visitVC = segue.destination as! VisitProfileVC
            let uid = sender as! String
            visitVC.uid = uid
            visitVC.delegate = self
        }
    }
    
}

extension PeopleVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
 
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension PeopleVC : PeopleTableViewCellDelegate {
    func goToProfileVC(userId: String) {
        self.performSegue(withIdentifier: "ProfileSegue", sender: userId)
    }
    
    
}


extension PeopleVC : HeaderProfileCollectionReusableViewDelegate{
    func updateFollowButton(forUser user: User) {
        print("update Follow Button for \(String(describing: user.id))")
        for u in users{
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
                break
            }
        }
    }
}

