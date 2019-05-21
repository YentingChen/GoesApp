//
//  String+.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

extension String {
    
    static func addressChangeMessage(placeName: String, placeFormatted: String) -> String {
        
        let message = "確認地址編輯為\n\(placeName)\n\(placeFormatted) ？"
        
        return message
    }
    
    static func formateTimeStamp(timeStamp: Int) -> String {
        
        let timeInterVal = TimeInterval(timeStamp)
        
        let date = Date(timeIntervalSince1970: timeInterVal)
        
        let dformatter = DateFormatter()
        
        dformatter.dateFormat = " yyyy年MM月dd日 HH:mm "
        
        let dateString = "\(dformatter.string(from: date))"
        
        return dateString
    }
    
    static func produceTime(order: OrderDetail)
        -> String {
            
            let year = order.selectTimeYear
            
            let month = { () -> String in
            
                if order.selectTimeMonth < 10 {
                    return "0\(order.selectTimeMonth)"
                } else {
                    return "\(order.selectTimeMonth)"
                }
            }()
            
            let day = { () -> String in
                
                if order.selectTimeDay < 10 {
                    
                    return "0\(order.selectTimeDay)"
                    
                } else {

                    return "\(order.selectTimeDay)"
                }
            }()
            
            let time = order.selectTimeTime
            
            return "\(year)/\(month)/\(day)   \(time)"
    }
    
}
