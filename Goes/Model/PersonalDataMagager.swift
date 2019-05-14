//
//  PersonalDataMagager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/15.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import Firebase

class PersonalDataManager: NSObject {
    
    var myProfile: MyProfile?
    var dataBase = Firestore.firestore()
    typealias CompletionHandler = (MyProfile?, Error?) -> Void
    let firebaseManager = FireAuthManager.share
    
    static let share = PersonalDataManager()
    
    let auth = Auth.auth()
    
    private override init() {}
    
    var authLitsener: AuthStateDidChangeListenerHandle?
    
    func getPersonalData(completionHandler completion: @escaping CompletionHandler) {
        
        if myProfile != nil {
            
            completion(myProfile!, nil)
            return
        }
        
        firebaseManager.addSignUpListener { (_, user) in
            
            guard user != nil else {
               
                guard let authListener = self.authLitsener else { return }
                Auth.auth().removeStateDidChangeListener(authListener)
                
                return }
            
            guard let userID = user?.uid else { return }
            let userProfile =  self.dataBase.collection("users").document(userID)
            userProfile.getDocument { [weak self] (document, _ ) in
                
                if let profile = document.flatMap({ $0.data().flatMap({ (data) in
                    return Profile(dictionary: data)
                })
                }) {
                    self?.myProfile = MyProfile(
                        email: profile.email,
                        userID: profile.userID,
                        userName: profile.userName,
                        phoneNumber: profile.phoneNumber,
                        avatar: profile.avatar,
                        fcmToken: profile.fcmToken)
                    completion(self?.myProfile, nil)
                    
                } else {
                    print("Document does not exist")
                }
                
            }
            
        }
    
}
}
