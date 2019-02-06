 //
//  SearchVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    var searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        //doSearch()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doSearch()
    }
    
    func doSearch() {
        if let searchText = self.searchBar.text?.lowercased() {
            self.users.removeAll()
            self.tableView.reloadData()
            Api.User.queryUser(withText: searchText) { (user:User) in
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
        print("segue.identifier =\(String(describing: segue.identifier))")
        if segue.identifier == "SearchToProfileSegue"{
            let visitProfileVC = segue.destination as! VisitProfileVC
            let userId = sender as! String
            visitProfileVC.uid = userId
            visitProfileVC.delegate = self
            print("userId=\(userId)")
            
        }
    }
    
}

 extension SearchVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         doSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
 }

 
 extension SearchVC : UITableViewDataSource {
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

 extension SearchVC : PeopleTableViewCellDelegate{
    func goToProfileVC(userId: String) {
        print("goToProfileVC from SearchVC")
        self.performSegue(withIdentifier: "SearchToProfileSegue", sender: userId)
    }
 }

 extension SearchVC : HeaderProfileCollectionReusableViewDelegate{
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
 

