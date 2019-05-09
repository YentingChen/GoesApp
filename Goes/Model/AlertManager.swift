//
//  AlertManager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit

enum AlertTitleName: String {
    case addressChanged = "地址變更"
}

//enum AlertMessage: String {
//    
//    case addressChanged = 
//    
//}

class AlertManager: NSObject {
    
    static let share = AlertManager()
    
    private override init() {}
    
    typealias CancelHandler = () -> Void
    
    typealias OkHandler = () -> Void
    
    func showAlert(title: String, message: String, viewController: UIViewController, typeOfAction: Int, okHandler: OkHandler?, cancelHandler: CancelHandler?) {
        
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            cancelHandler?()
        }
        
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            _ in
            okHandler?()
        })
        
        switch typeOfAction {
            
        case 1:
            
            alertController.addAction(okAction)
            
        case 2:
            
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
        case 3:
            
            alertController.addAction(cancelAction)
            
        default:
            break
        }
    
        viewController.present(alertController, animated: false, completion: nil)
    
    }
    
}
