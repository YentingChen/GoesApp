//
//  FriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase

class FriendListViewController: UIViewController {
    
    let personalDataManager = PersonalDataManager()
    
    var myProfile : MyProfile?
    
    var myFriends = [String]()
    
    var dataBase = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
            self.querymyFriends()
            print(error as Any)
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "FriendListTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "friendListTableViewCell")

    }
    
    func querymyFriends() {
        guard let myUid = myProfile?.userID else { return }
        dataBase.collection("users").document(myUid).collection("friend").getDocuments
            {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let status = document.data()["status"] as? Int {
                            if  status == 3 {
                                self.myFriends.append(document.documentID)
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
    }
    
    func queryFriendName(friendUserID: String, completionHandler: @escaping (String) -> Void) {
        var friendName = String()
        dataBase.collection("users").document(friendUserID).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let dbFriendName = querySnapshot?.data()!["userName"] as? String else { return }
                friendName = dbFriendName
                completionHandler(friendName)
            }
        }
        
    }
    
    func deleteFriend(number: Int) {
        guard let myUid = myProfile?.userID else { return }
    dataBase.collection("users").document(myUid).collection("friend").document(myFriends[number]).delete{ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    dataBase.collection("users").document(myFriends[number]).collection("friend").document(myUid).delete{ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendListTableViewCell",
            for: indexPath) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        
        queryFriendName(
            friendUserID: myFriends[indexPath.row],
            completionHandler: { friendName in
            cell.cellLabel.text = friendName
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, view, completionHandler) in
            self.deleteFriend(number: indexPath.row)
            self.tableView.reloadData()
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "朋友列表(2)"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
