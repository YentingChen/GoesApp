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
  
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()
        self.friendView.isHidden = true

    }

    @IBAction func searchBtn(_ sender: Any) {
        guard let friendEmail = searchFriend.text else { return }
        
        db.collection("users")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let email = document.data()["email"], let searchEmail = self.searchFriend.text {
                            if  searchEmail == email as? String {
                                self.friendView.isHidden = false
                                if let friendName = document.data()["userName"] {
                                    self.friendName.text = friendName as? String
                                    
                                }
                            }
                        }
                        print("\(document.documentID) => \(document.data())")
                        print(document.data()["email"])
                    }
                }
        }
//        Auth.auth().fetchProviders(forEmail: friendEmail) { (providers, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let providers = providers {
//                print(providers)
//            }
//        }
    }

}
