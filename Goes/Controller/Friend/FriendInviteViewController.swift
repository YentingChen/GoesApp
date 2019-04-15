//
//  FriendInviteViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase

class FriendInviteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendInviteTableViewCell", bundle: nil), forCellReuseIdentifier: "friendInviteTableViewCell")
        queryInviteFriend() 

    }
    func queryInviteFriend() {
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.value(forKey: "uid") as? String {
            db.collection("users").document(userID).collection("friend").getDocuments {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let status = document.data()["status"] as? Int {
                            if  status == 0 {
                                print(document.documentID)
                            }
                        }
                    }
                    
                }
            }
        }
        
    }

}

extension FriendInviteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendInviteTableViewCell", for: indexPath) as? FriendInviteTableViewCell else { return  UITableViewCell() }
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
