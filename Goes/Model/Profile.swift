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
    
    init(dictionary: [String: Any]){
        self.email = (dictionary["email"] as? String)!
        self.userID = (dictionary["userID"] as? String)!
        self.userName = (dictionary["userName"] as? String)!
        self.avatar = (dictionary["avatar"] as? String)!
        self.phoneNumber = (dictionary["phoneNumber"] as? String)!
    }
}

struct MyProfile {
    var email: String
    var userID: String
    var userName: String
    var phoneNumber: String
    var avatar: String
}

struct AddressFromDB {
    var placeID: String
    var placeLat: Double
    var placeLng: Double
    var placeName: String
    var placeformattedAddress: String
    
    init(dictionary: [String: Any]){
        self.placeID = (dictionary["placeID"] as? String) ?? ""
        self.placeLat = (dictionary["placeLat"] as? Double) ?? 0
        self.placeLng = (dictionary["placeLng"] as? Double) ?? 0
        self.placeName = (dictionary["placeName"] as? String) ?? ""
        self.placeformattedAddress = (dictionary["placeformattedAddress"] as? String) ?? ""
        
       
    }
    
}
    
    struct Address {
        var placeID: String
        var placeLat: Double
        var placeLng: Double
        var placeName: String
        var placeformattedAddress: String
        
    }

struct DateAndTime {
    var date: Date
    var year: Int
    var month: Int
    var time: String
    var day: Int
}
