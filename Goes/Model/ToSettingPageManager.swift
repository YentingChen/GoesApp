//
//  ToSettingUpPage.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit

class ToSettingPageManager: NSObject {
    
    static let share = ToSettingPageManager()
    
    private override init() {}
    
    func toSettingPage() {
        
        let url = URL(string: UIApplication.openSettingsURLString) 
        
        if let url = url, UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10, *) {
                
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
