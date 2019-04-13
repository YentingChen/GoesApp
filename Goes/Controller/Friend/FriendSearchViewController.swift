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

class FriendSearchViewController: UIViewController {
    @IBOutlet weak var searchFriend: UITextField!
    var db : Firestore!
  
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()

    }

    @IBAction func searchBtn(_ sender: Any) {
        guard let friendEmail = searchFriend.text else { return }
        
        db.collection("users")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
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
