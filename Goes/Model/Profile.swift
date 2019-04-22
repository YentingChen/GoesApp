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
    var date: Int
    var year: Int
    var month: Int
    var time: String
    var day: Int
}

struct OrderFromDB {
    
    var driverUid: String
    var riderUid: String
    var locationFormattedAddress: String
    var selectedLat: Double
    var selectedLng: Double
    var locationName: String
    var locationPlaceID: String
    var selectTimeDate : Int
    var selectTimeDay: Int
    var selectTimeYear: Int
    var selectTimeMonth: Int
    var selectTimeTime: String
    var orderID: String
    
    init(dictionary: [String: Any]) {
        
        self.driverUid = (dictionary["driverUid"] as? String)!
        self.riderUid = (dictionary["riderUid"] as? String)!
        self.locationFormattedAddress = (dictionary["location_formattedAddress"] as? String)!
        self.selectedLat = Double((dictionary["selected_location_lat"] as? NSNumber)!)
        self.selectedLng = Double((dictionary["selected_location_lng"] as? NSNumber)!)
        self.locationName = (dictionary["selected_location_name"] as? String)!
        self.locationPlaceID = (dictionary["selected_location_placeID"] as? String)!
        self.selectTimeDate = Int(((dictionary["selected_time_date"] as? NSNumber )!))
        self.selectTimeDay = Int((dictionary["selected_time_day"] as? NSNumber)!)
        self.selectTimeYear =  Int((dictionary["selected_time_year"] as? NSNumber)!)
        self.selectTimeMonth = Int((dictionary["selected_time_month"] as? NSNumber)!)
        self.selectTimeTime = (dictionary["selected_time_time"] as? String)!
        self.orderID = (dictionary["order_ID"] as? String)!

    }
}

struct OrderDetail {
    
    var driverUid: String
    var riderUid: String
    var locationFormattedAddress: String
    var selectedLat: Double
    var selectedLng: Double
    var locationName: String
    var locationPlaceID: String
    var selectTimeDate : Int
    var selectTimeDay: Int
    var selectTimeYear: Int
    var selectTimeMonth: Int
    var selectTimeTime: String
    var orderID: String
}
