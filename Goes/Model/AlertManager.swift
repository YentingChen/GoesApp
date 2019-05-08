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

extension String {
    static func addressChangeMessage(placeName: String, placeFormatted: String) -> String {
        let message = "確認地址編輯為\n\(placeName)\n\(placeFormatted) ？"
        return message
    }
}

//extension UIImage {
//
//    static func asset(_ asset: ImageAsset) -> UIImage? {
//
//        return UIImage(named: asset.rawValue)
//    }
//}

class AlertManager {
    
    typealias CancelHandler = () -> Void
    typealias OkHandler = () -> Void
    
    func showAlert(title: String, message: String, vc: UIViewController, okHandler: @escaping OkHandler, cancelHandler: @escaping CancelHandler) {
        
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            cancelHandler()
        }
        
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            okHandler()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: false, completion: nil)
    
    }
    
}
