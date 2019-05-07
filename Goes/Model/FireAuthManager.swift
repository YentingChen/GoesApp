//
//  FireAuthManager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct YTUser {
    
    var id: String?
    var email: String?
    
}

class FireAuthManager: NSObject {
    
    static let share = FireAuthManager()
    
    private override init() {}
    
    let auth = Auth.auth()
    
    var addStateListener: AuthStateDidChangeListenerHandle?
    
    func addSignUpListener(listener: @escaping (Bool, User?) -> Void) {
        
        addStateListener = auth.addStateDidChangeListener { (_, user) in
            
            guard user != nil else {
                listener(false, nil)
                return
            }
            
            listener(true, user)
        }
    }
    
    func deleteListener() {
        
        if let listener = addStateListener {
            auth.removeStateDidChangeListener(listener)
        }
        
    }
    
    func getCurrentUser() -> YTUser? {
        let user = Auth.auth().currentUser
        
        var ytUser = YTUser()
        
        ytUser.email = user?.email
        ytUser.id = user?.uid
        
        return ytUser
    }
    
    func createAccountAction(email: String, password: String, completionHandler: @escaping () -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                
            }
        }
//            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!)}

    }
    
}
