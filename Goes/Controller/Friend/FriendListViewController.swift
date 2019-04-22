//
//  FriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class FriendListViewController: UIViewController {
    
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var myFriends = [MyProfile]()
    
    var result = [MyProfile]()
    var isSearching = false

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDB()
        
        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "FriendListTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "friendListTableViewCell")

    }
    
     func deleteFriend(number: Int) {
        
        self.fireBaseManager.deleteFriend(
        myUid: (self.myProfile?.userID)!,
        friendUid: self.myFriends[number].userID) {
            
            self.myFriends.remove(at: number)
            self.tableView.reloadData()
        }
        
    }
    
    func loadDataFromDB() {
        
        personalDataManager.getPersonalData { [weak self] (myProfile, error) in
            self?.myProfile = myProfile
            self?.fireBaseManager.querymyFriends(
                myUid: (self?.myProfile?.userID)!,
                status: 3,
                completionHandler: { (friendInfos) in
                    
                self?.myFriends = friendInfos
                    
                self?.tableView.reloadData()
            })
        }
    }
    
    fileprivate func showAlert(number: Int) {
        
        let alertController = UIAlertController(
            title: "",
            message: "您確定要刪除 \(self.myFriends[number].userName) 嗎？",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "確認", style: .default) { (action) in
            self.deleteFriend(number: number)
        }
        
        self.present(alertController, animated: true, completion: nil)
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(deleteAction)
    }
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            
            return result.count
            
        } else {
            
            return myFriends.count
        }

      
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendListTableViewCell",
            for: indexPath) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        if isSearching {
            
            cell.cellLabel.text = self.result[indexPath.row].userName
            
            
        } else {
            
            cell.cellLabel.text = self.myFriends[indexPath.row].userName
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
        style: .normal,
        title: "刪除好友") { (action, sourceView, completionHandler) in
            self.showAlert(number: indexPath.row)
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }

}

extension FriendListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText == "" {
            isSearching = false
            
        } else {
            self.result = []
            isSearching = true
            
            for name in self.myFriends.filter(( {$0.userName.lowercased().hasPrefix(searchText.lowercased())} )) {
                
                self.result.append(name)
                
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        isSearching = false
        
        self.tableView.reloadData()
        
    }
    
    
}
