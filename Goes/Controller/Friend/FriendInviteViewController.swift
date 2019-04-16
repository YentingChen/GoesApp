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
    
    let personalDataManager = PersonalDataManager()
    var myProfile : MyProfile?
    var inviteFriend = [String]()
    @IBOutlet weak var tableView: UITableView!
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
            self.queryInviteFriend()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendInviteTableViewCell", bundle: nil), forCellReuseIdentifier: "friendInviteTableViewCell")

    }
    
    func queryInviteFriend() {
        guard let myUid = self.myProfile?.userID else { return }
        
            db.collection("users").document(myUid).collection("friend").getDocuments {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let status = document.data()["status"] as? Int {
                            if  status == 2 {
                                self.inviteFriend.append(document.documentID)
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        
        
    }
    
    func queryFriendName(friendUserID: String, completionHandler: @escaping (String) -> Void) {
        var friendName = String()
        db.collection("users").document(friendUserID).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let dbFriendName = querySnapshot?.data()!["userName"] as? String else { return }
                friendName = dbFriendName
                completionHandler(friendName)
            }
        }
        
    }

}

extension FriendInviteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteFriend.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendInviteTableViewCell", for: indexPath) as? FriendInviteTableViewCell else { return  UITableViewCell() }
        queryFriendName(friendUserID: inviteFriend[indexPath.row], completionHandler: { friendName in
            cell.cellLabel.text = friendName
        })
        
        cell.checkBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(makeFriend(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(cancleInvite(_:)), for: .touchUpInside)
        
        return cell

    }
    
    @objc func cancleInvite(_ sendr: UIButton) {
        db.collection("users").document((self.myProfile?.userID)!).collection("friend").document(inviteFriend[sendr.tag]).delete{ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        db.collection("users").document(inviteFriend[sendr.tag]).collection("friend").document((self.myProfile?.userID)!).delete{ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    @objc func makeFriend(_ sendr: UIButton) {
        db.collection("users").document((self.myProfile?.userID)!).collection("friend").document(inviteFriend[sendr.tag]).updateData(["status":3])
        db.collection("users").document(inviteFriend[sendr.tag]).collection("friend").document((self.myProfile?.userID)!).updateData(["status":3])
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
