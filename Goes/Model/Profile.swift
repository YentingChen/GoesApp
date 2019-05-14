//
//  Profile.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/12.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

struct SetProfile {
    
    var email: String
    var userID: String
    var userName: String
    var phoneNumber: String
    var avatar: String
    
    enum CodingKeys: String, CodingKey {
        
        case email
        case userID
        case userName
        case phoneNumber
        case avatar
    }
}

struct Profile {
    
    var email: String
    var userID: String
    var userName: String
    var phoneNumber: String
    var avatar: String
    var fcmToken: String
    
    init(dictionary: [String: Any]) {
        self.email = (dictionary["email"] as? String ?? "")
        self.userID = (dictionary["userID"] as? String ?? "")
        self.userName = (dictionary["userName"] as? String ?? "")
        self.avatar = (dictionary["avatar"] as? String ?? "")
        self.phoneNumber = (dictionary["phoneNumber"] as? String ?? "")
        self.fcmToken = (dictionary["fcmToken"] as? String ?? "")
    }
}

struct MyProfile {
    
    var email: String
    var userID: String
    var userName: String
    var phoneNumber: String
    var avatar: String
    var fcmToken: String
    
}
