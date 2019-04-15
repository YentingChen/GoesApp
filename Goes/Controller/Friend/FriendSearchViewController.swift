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
    var personalDataManager = PersonalDataManager()
    var db = Firestore.firestore()
    var myProfile: MyProfile?
    var friendStatusNumber = 0

    var friendUid = String()
  
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendView.isHidden = true
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
        }

    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "錯誤",
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
       
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        distinguishStatus()
       
       
    }
    
    func friendStatus() {
        db.collection("users").document((myProfile?.userID)!).collection("friend").document(friendUid).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let statusNumber = (querySnapshot?.data()!["status"] as? Int)  else { return }
                self.friendStatusNumber = statusNumber
            }
            switch self.friendStatusNumber {
            case 1 : self.showAlert(message: "您已經寄出邀請了...")
            case 2 : self.showAlert(message: " = = 請回覆別人的邀請好嗎？")
            default :
                self.sentInvite()
                self.friendRecieve()
            }
        }
    }
    
    func distinguishStatus() {
        guard let friendEmail = self.searchFriend.text else { return }
        guard friendEmail != "" else { return }
        guard friendEmail != myProfile?.email else {
            showAlert(message: "您邊緣人嗎？ 為什麼要加自己成為好友？")
            return
        }
        friendStatus()
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
