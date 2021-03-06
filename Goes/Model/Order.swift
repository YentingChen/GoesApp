//
//  Order.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

struct OrderFromDB {
    
    var driverUid: String
    var riderUid: String
    var locationFormattedAddress: String
    var selectedLat: Double
    var selectedLng: Double
    var locationName: String
    var locationPlaceID: String
    var selectTimeDate: Int
    var selectTimeDay: Int
    var selectTimeYear: Int
    var selectTimeMonth: Int
    var selectTimeTime: String
    var orderID: String
    var driverLat: Double
    var driverLag: Double
    var riderLat: Double
    var riderLag: Double
    var setOff: Int
    var driverStartLat: Double
    var driverStartLag: Double
    var driverStartTime: Int
    var completeTime: Int
    
    init(dictionary: [String: Any]) {
        
        self.driverUid = (dictionary["driverUid"] as? String)!
        self.riderUid = (dictionary["riderUid"] as? String)!
        self.locationFormattedAddress = (dictionary["location_formattedAddress"] as? String)!
        self.selectedLat = Double(truncating: (dictionary["selected_location_lat"] as? NSNumber ?? 0))
        self.selectedLng = Double(truncating: (dictionary["selected_location_lng"] as? NSNumber)!)
        self.locationName = (dictionary["selected_location_name"] as? String)!
        self.locationPlaceID = (dictionary["selected_location_placeID"] as? String ?? "")
        self.selectTimeDate = Int(truncating: dictionary["selected_time_date"] as? NSNumber ?? 0)
        self.selectTimeDay = Int(truncating: dictionary["selected_time_day"] as? NSNumber ?? 0)
        self.selectTimeYear =  Int(truncating: (dictionary["selected_time_year"] as? NSNumber ?? 0))
        self.selectTimeMonth = Int(truncating: (dictionary["selected_time_month"] as? NSNumber)!)
        self.selectTimeTime = (dictionary["selected_time_time"] as? String ?? "")
        self.orderID = (dictionary["order_ID"] as? String ?? "")
        self.driverLag = Double(truncating: dictionary["driverLag"] as? NSNumber ?? 0)
        self.driverLat = Double(truncating: dictionary["driverLat"] as? NSNumber ?? 0)
        self.riderLag = Double(truncating: dictionary["riderLag"] as? NSNumber ?? 0)
        self.riderLat = Double(truncating: dictionary["riderLat"] as? NSNumber ?? 0)
        self.setOff = Int(truncating: dictionary["setOff"] as? NSNumber ?? 0)
        self.driverStartLat = Double(truncating: dictionary["driver_start_Lat"] as? NSNumber ?? 0)
        self.driverStartLag = Double(truncating: dictionary["driver_start_lag"] as? NSNumber ?? 0)
        self.driverStartTime = Int(truncating: dictionary["driver_start_time"] as? NSNumber ?? 0)
        self.completeTime = Int(truncating: dictionary["complete_time"] as? NSNumber ?? 0)
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
    var selectTimeDate: Int
    var selectTimeDay: Int
    var selectTimeYear: Int
    var selectTimeMonth: Int
    var selectTimeTime: String
    var orderID: String
    var driverLat: Double
    var driverLag: Double
    var riderLat: Double
    var riderLag: Double
    var setOff: Int
    var driverStartLat: Double
    var driverStartLag: Double
    var driverStartTime: Int
    var completeTime: Int
    
}
