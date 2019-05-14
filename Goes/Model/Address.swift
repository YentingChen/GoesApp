//
//  Address.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

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

