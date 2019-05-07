//
//  UISegmentControl+.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    func removeBorder() {
        self.layer.cornerRadius = 0.0
        self.tintColor = .white
        self.backgroundColor = .white
        self.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.G1,
             NSAttributedString.Key.backgroundColor: UIColor.white,
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)], for: .selected)
        self.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 136/255)],
            for: .normal)
    }
    
    func addUnderlineForSelectedSegment() {
        
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 3.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 0.5
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.G1
        underline.tag = 1
        self.addSubview(underline)
    }
    
    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
            underline.layer.zPosition = 0.2
        })
}
}
