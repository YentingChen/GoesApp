//
//  FirebaseManager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/16.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FireAuthManager {
    func addSignUpListener(listener: @escaping (Bool) -> Void) {
        
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            
            guard user != nil else {
                listener(false)
                return
            }
            
            listener(true)
        }
    }
}

class FireBaseManager {
    var db = Firestore.firestore()
    var userProfile : MyProfile?
   
    func queryUsers(email: String, completionHandler: @escaping (Bool, String) -> Void) {
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        guard let fireEmail = document.data()["email"] else { return }
                            if  email == fireEmail as? String {
                                let friendUid = document.data()["userID"] as? String
                                completionHandler(true, friendUid! )
                            }
                               
                        }
                }
                
            }
        }
    
    func queryFriendStatus(friendUid: String, myUid: String, completionHandler: @escaping (Int) -> Void) {
        db.collection("users").document(myUid).collection("friend").document(friendUid).getDocument { (document, err) in
            if document?.data() != nil {
                
                let status = document?.data()!["status"] as? Int
                guard let friendStatus = status else { return }
                completionHandler(friendStatus)
                
            } else {
                completionHandler(0)

            }
        }
    }
    
    
    func makeFriend(friendUid: String, myUid: String){
        db.collection("users").document(myUid).collection("friend").document(friendUid).setData(["status":1])
        db.collection("users").document(friendUid).collection("friend").document(myUid).setData(["status":2])
        
    }
    
    typealias CompletionHandler = (MyProfile?) -> Void
    func queryUserInfo(userID: String, completion: @escaping CompletionHandler) {
        let userProfile =  db.collection("users").document(userID)
        userProfile.getDocument { (document, error) in
            
            if let profile = document.flatMap({ $0.data().flatMap({ (data) in
                return Profile(dictionary: data)
            })
            }) {
                self.userProfile = MyProfile(
                    email: profile.email,
                    userID: profile.userID,
                    userName: profile.userName,
                    phoneNumber: profile.phoneNumber,
                    avatar: profile.avatar)
                print("Profile: \(profile)")
            completion(self.userProfile)
            } else {
                print("Document does not exist")
            }
            
        }
    }
}
