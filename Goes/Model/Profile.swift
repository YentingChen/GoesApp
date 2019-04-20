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
    
    init(dictionary: [String: Any]) {
        
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

struct OrderFromDB {
    
    var driverUid: String
    var riderUid: String
    var locationFormattedAddress: String
    var selectedLat: Int
    var selectedLng: Int
    var locationName: String
    var selectTimeDate : Date
    var selectTimeDay: Int
    var selectTimeYear: Int
    var selectTimeMonth: Int
    var selectTimeTime: String
    
    init(dictionary: [String: Any]){
        
        self.driverUid = (dictionary["driverUid"] as? String)!
        self.riderUid = (dictionary["riderUid"] as? String)!
        self.locationFormattedAddress = (dictionary["location_formattedAddress"] as? String)!
        self.selectedLat = (dictionary["selected_location_lat"] as? Int)!
        self.selectedLng = (dictionary["selected_location_lng"] as? Int)!
        self.locationName = (dictionary["selected_location_name"] as? String)!
        self.selectTimeDate = (dictionary["selected_time_date"] as? Date)!
        self.selectTimeDay = (dictionary["selected_time_day"] as? Int)!
        self.selectTimeYear =  (dictionary["selected_time_year"] as? Int)!
        self.selectTimeMonth = (dictionary["selected_time_month"] as? Int)!
        self.selectTimeTime = (dictionary["selected_time_time"] as? String)!

    }
    
    struct Order {
        
        var driverUid: String
        var riderUid: String
        var locationFormattedAddress: String
        var selectedLat: Int
        var selectedLng: Int
        var locationName: String
        var selectTimeDate : Date
        var selectTimeDay: Int
        var selectTimeYear: Int
        var selectTimeMonth: Int
        var selectTimeTime: String
        
    }
    
}
