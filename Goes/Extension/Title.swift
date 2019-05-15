//
//  Title.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation

enum Title: String {
    
    //ProfileAddress
    case home = "住家"
    case company = "公司"
    case favorite = "常用"
    
    //ProfileMyInfo
    case name = "姓名"
    case email = "email"
    case phone = "手機"

    //NotificationTitile
    case driverSetOff = "您的朋友已經出發"
}

enum NotificationMessage: String {

    case driverSetOff = "已經出發!"
        
}
