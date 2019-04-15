//
//  PersonalDataMagager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/15.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import Firebase

class PersonalDataManager {
    
    var myProfile: MyProfile?
    var dataBase = Firestore.firestore()
    typealias CompletionHandler = (MyProfile?, Error?) -> Void
    func getPersonalData(completionHandler completion: @escaping CompletionHandler) {
        
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            
            guard user != nil else { return }
            
            guard let userID = user?.uid else { return }
            
            let userProfile =  self?.dataBase.collection("users").document(userID)
            
            userProfile?.getDocument { (document, error) in
                
                if let profile = document.flatMap({
                    $0.data().flatMap({ (data) in
                        return Profile(dictionary: data)
                        
                    })
                }) {
                    self?.myProfile = MyProfile(
                        email: profile.email,
                        userID: profile.userID,
                        userName: profile.userName,
                        phoneNumber: profile.phoneNumber,
                        avatar: profile.avatar)
                    completion(self?.myProfile, nil)
                    print("Profile: \(profile)")
                } else {
                    print("Document does not exist")
                }
                
            }
        }
    }
}
