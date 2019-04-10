//
//  LobbyFindMyFriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/10.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire


class LobbyFindMyFriendViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMap: GMSMapView!
    var marker = GMSMarker()
    var sourceLat = 23.0225
    var sourceLong = 72.5714
    var bsourceLat = 24.0225
    var bsourceLong = 73.5714
    var rectangle = GMSPolyline()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sLat = String(sourceLat)
        let sLong = String(sourceLat)
        let bsLat = String(bsourceLat)
        let bsLong = String(bsourceLong)
        let aPoint = "\(sLat),\(sLong)"
        let bPoint = "\(bsLat),\(bsLong)"
        
        let request = URLRequest(url: URL(string: "")!)
        Alamofire.request(request)
        
    }
    
   
    
   
}
