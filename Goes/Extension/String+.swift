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
                if order.selectTimeMonth < 0 || order.selectTimeMonth > 12 {
                    return "月份錯誤，請輸入正確的月份，您輸入為\(order.selectTimeMonth)"
                }
            
                if order.selectTimeMonth < 10 && order.selectTimeMonth > 0  {
                    return "0\(order.selectTimeMonth)"
                } else {
                    return "\(order.selectTimeMonth)"
                }
            }()
            
            let day = { () -> String in
                
                if order.selectTimeDay < 0 || order.selectTimeDay > 31 {
                    
                    return "日期錯誤，請輸入正確的日期，您輸入為\(order.selectTimeMonth)"
                }
                
                if order.selectTimeDay < 10 && order.selectTimeDay > 0 {
                    
                    return "0\(order.selectTimeDay)"
                    
                } else {
                    
                    if order.selectTimeDay == 31,
                    order.selectTimeMonth == 2 ||
                    order.selectTimeMonth == 4 ||
                    order.selectTimeMonth == 6 ||
                    order.selectTimeMonth == 9 ||
                    order.selectTimeMonth == 11 {
                        
                        return "日期錯誤，該月份無 31 號"
                    } else if order.selectTimeDay == 30,
                        order.selectTimeMonth == 2 {
                        return "日期錯誤，該月份無 30 號"
                    }
                    
                    
                    
                    return "\(order.selectTimeDay)"
                }
            }()
            
            let hour = { () -> String in
                
                guard order.selectTimeTime.contains(":") else {
                    
                    return "時間錯誤，時間輸入格式應為 hh:mm，您輸入為 \(order.selectTimeTime)"
                }
                
                let timeHourMin = order.selectTimeTime.components(separatedBy: ":")
                
                let timeHour = Int(timeHourMin[0])
                
                let timeMin = Int(timeHourMin[1])
                
                if timeHour != nil && timeHour! >= 0 && timeHour! < 24 {
                    
                    return "\(timeHour!)"
                    
                } else if timeHour == 24 && timeMin! > 0 {
                    
                    return "00"
                    
                } else {
                    
                    return "時間錯誤：不應該出現\(timeHour!)小時"
                }
            }()
        
            let min = { () -> String in
                
                guard order.selectTimeTime.contains(":") else {
                    return "時間錯誤，時間輸入格式應為 hh:mm"
                }
                
                let timeHourMin = order.selectTimeTime.components(separatedBy: ":")
                
                let timeHour = Int(timeHourMin[0])
                
                let timeMin = Int(timeHourMin[1])
                
                if timeMin != nil && timeMin! >= 0 && timeMin! <= 60 {
                    
                    if timeMin! < 10 {
                        
                        return "0\(timeMin!)"
                        
                    } else {
                        
                        return "\(timeMin!)"
                    }
                } else {
                    return "00"
                }
                
            }()
            
//            let time = order.selectTimeTime
            
            return "\(year)/\(month)/\(day)   \(hour):\(min)"
    }
    
}
