//
//  FriendSentViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase

class FriendSentViewController: UIViewController {
    var db = Firestore.firestore()
    let personalDataManager = PersonalDataManager()
    var myProfile : MyProfile?
    var sentFriend = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
            self.querySentFriend()
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FriendSentTableViewCell", bundle: nil), forCellReuseIdentifier: "friendSentTableViewCell")
        tableView.separatorStyle = .none
        
    }
    
    func querySentFriend() {
        db.collection("users").document((self.myProfile?.userID)!).collection("friend").getDocuments {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let status = document.data()["status"] as? Int {
                            if  status == 1 {
                                self.sentFriend.append(document.documentID)
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
    
    @objc func cancleSent(_ sendr: UIButton) {
        guard let myUid = self.myProfile?.userID else { return }
        db.collection("users").document(myUid).collection("friend").document(sentFriend[sendr.tag]).delete{ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
           
        }
        db.collection("users").document(sentFriend[sendr.tag]).collection("friend").document(myUid).delete{ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
         self.tableView.reloadData()
    }
   
}

extension FriendSentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentFriend.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendSentTableViewCell", for: indexPath) as? FriendSentTableViewCell else { return UITableViewCell()}
              
        queryFriendName(friendUserID: sentFriend[indexPath.row], completionHandler: { friendName in
            cell.cellLabel.text = friendName
        })
        cell.cancleInviteButton.tag = indexPath.row
        cell.cancleInviteButton.addTarget(self, action: #selector(cancleSent(_:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
