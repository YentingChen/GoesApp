//
//  UIView+Extension.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
//extension UIView {
//
//    //Border Color
//    @IBInspectable var YTBorderColor: UIColor? {
//        get {
//
//            guard let borderColor = layer.borderColor else {
//
//                return nil
//            }
//
//            return UIColor(cgColor: borderColor)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//    //Border width
//    @IBInspectable var YTBorderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    //Corner radius
//    @IBInspectable var YTCornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//}
//
//    @IBInspectable var YTShadowPath: CGPath? {
//        get {
//            return layer.shadowPath
//        }
//        set {
//            layer.shadowPath = newValue
//        }
//    }
//
//    @IBInspectable var YTShadowColor: CGColor? {
//        get {
//            return layer.shadowColor
//        }
//        set {
//            layer.shadowColor = newValue
//        }
//    }
//
//    @IBInspectable var YTShadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//
//    @IBInspectable var YTShadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    @IBInspectable var YTShadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//}

extension UIView {
    
    func lock() {
        if let _ = viewWithTag(10) {
            //View is already locked
        } else {

            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor.white
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(style: .gray)
            activity.hidesWhenStopped = true
            activity.center = lockView.center
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 1.0
            })
        }
    }
    
    func unlock() {
        if let lockView = viewWithTag(10) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.0
            }, completion: { finished in
                lockView.removeFromSuperview()
            })
        }
    }
    
    func fadeOut(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func fadeIn(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    class func viewFromNibName(_ name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views?.first as? UIView
    }
}


