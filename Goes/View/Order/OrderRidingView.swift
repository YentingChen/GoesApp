//
//  OrderRidingView.swift
//  Goes
//
//  Created by Yenting Chen on 2019/6/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMaps

class OrderRidingView: UIView {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var arrivingAddressLabel: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var timeBackgroundView: UIView!
    @IBOutlet weak var successfulImage: UIImageView!
    
    func showAvatar(url: String) {
        
        let url = URL(string: url)
        
        avatar.kf.setImage(with: url)
        avatar.roundCorners(avatar.frame.width/2)
        avatar.clipsToBounds = true
        
    }
    
}
