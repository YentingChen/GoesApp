//
//  OrderDrivingView.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps

protocol OrderViewDelegate: AnyObject {
    
    func setOffAction(_ view: OrderDrivingView, didTapButton button: UIButton)
    
    func callAction(_ view: OrderDrivingView, didTapButton button: UIButton)
    
}

class OrderDrivingView: UIView, GMSMapViewDelegate {
    
    weak var delegate: OrderViewDelegate?

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var arrivingTimeLabel: UILabel!
    @IBOutlet weak var arrivingAddressLabel: UILabel!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var setOffBtn: UIButton!
    @IBOutlet weak var timeBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.delegate = self
        
        setOffBtn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        callBtn.addTarget(self, action: #selector(didTapCallBtn(_:)), for: .touchUpInside)
        
        timeBackgroundView.roundCorners(20)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func didTapButton(_ button: UIButton) {
        
        delegate?.setOffAction(self, didTapButton: button)
    }
    
    @objc func didTapCallBtn(_ button: UIButton) {
        
        delegate?.callAction(self, didTapButton: button)
    }
    
    func showAvatar(url: String) {
        
        let url = URL(string: url)
        
        avatar.kf.setImage(with: url)
        avatar.roundCorners(avatar.frame.width/2)
        avatar.clipsToBounds = true
        
    }
    
}
