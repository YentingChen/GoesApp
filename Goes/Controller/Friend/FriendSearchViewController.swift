//
//  FriendSearchViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FriendSearchViewController: UIViewController {
    @IBOutlet weak var searchFriend: UITextField!
    var db : Firestore!
    var friendUid = String()
  
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()
        self.friendView.isHidden = true

    }
    @IBAction func searchBtn(_ sender: Any) {
        db.collection("users")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let email = document.data()["email"], let searchEmail = self.searchFriend.text {
                            if  searchEmail == email as? String {
                                self.friendView.isHidden = false
                                if let friendName = document.data()["userName"], let friendUserId = document.data()["userID"] as? String {
                                    self.friendName.text = friendName as? String
                                    self.friendUid = friendUserId
                                }
                            }
                        }
                        print("\(document.documentID) => \(document.data())")
                        print(document.data()["email"])
                    }
                }
        }
    }
    
    @IBAction func addFriend(_ sender: Any) {
        sentInvite()
        friendRecieve()
    }
    
    func sentInvite() {
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.value(forKey: "uid") as? String {
            db.collection("users").document(userID).collection("friend").document(friendUid).setData(["status":1])
        }
    }
    
    func friendRecieve() {
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.value(forKey: "uid") as? String {
            db.collection("users").document(friendUid).collection("friend").document(userID).setData(["status":2])
        }
        
    }


}
