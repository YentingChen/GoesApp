//
//  Profile.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/12.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

struct Profile {
    var email: String
    var userID: String
    var userName: String
    var phoneNumber: String
    var avatar: String
    
    init(dictionary: [String: Any]){
        self.email = (dictionary["email"] as? String)!
        self.userID = (dictionary["uid"] as? String)!
        self.userName = (dictionary["name"] as? String)!
        self.avatar = (dictionary["avatar"] as? String)!
        self.phoneNumber = (dictionary["phone"] as? String)!
    }
}

struct MyProfile {
    var email: String
    var userID: String
    var userName: String
    var phoneNumber: String
    var avatar: String
}
