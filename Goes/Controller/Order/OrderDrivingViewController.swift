//
//  OrderDrivingViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/22.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class OrderDrivingViewController: UIViewController {
    
    var timer: Timer?
    var isOntheWay = false
    
    private let locationManager = CLLocationManager()
    
    var orderRequestVC: OrderRequestViewController?
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?
    var updateLat = Double()
    var updateLag = Double()

    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var arrivingAddress: UILabel!
    
    @IBAction func startDriving(_ sender: Any) {
        self.isOntheWay = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.arrivingAddress.text = self.order?.locationFormattedAddress
        self.riderName.text = self.rider?.userName
        
        
        updateDriverLocation()
    }
    
    func updateDriverLocation() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            if self.updateLat != nil && self.updateLag != nil {
                if self.updateLat != 0 && self.updateLag != 0 {
                    self.fireBaseManager.updateDriverLocation(orderID: (self.order?.orderID)!, lat: self.updateLat, lag: self.updateLag)
                }
            }
        })
    }

}

extension OrderDrivingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.updateLat = Double(location.coordinate.latitude)
        self.updateLag = Double(location.coordinate.longitude)
        
    }
    
//    func drawPath(location: CLLocation) {
//
//        let origin = "\(self.order!.selectedLat),\(self.order!.selectedLng)"
//        let destination = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
//
//        Alamofire.request(url).responseJSON { response in
//
//            do {
//                let json = try JSON(data: response.data!)
//                let routes = json["routes"].arrayValue
//                let timeTxt = json["routes"][0]["legs"][0]["duration"]["text"]
//                let timeValue = json["routes"][0]["legs"][0]["duration"]["value"].rawValue as? Int
//                if timeValue != nil {
//
//                    let current = Int(Date().timeIntervalSince1970) + timeValue!
//                    let dformatter = DateFormatter()
//                    let date = Date(timeIntervalSince1970: TimeInterval(current))
//                    dformatter.dateFormat = "HH:mm"
//                    self.estimateTime.text = dformatter.string(from: date)
//                    print("对应的日期时间：\(dformatter.string(from: date))")
//
//                } else {
//                    self.estimateTime.text = " -- : -- "
//                }
//
//                for route in routes {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//                    let polyline = GMSPolyline.init(path: path)
//                    polyline.map = self.mapView
//                    polyline.strokeColor = UIColor.G1!
//                    polyline.strokeWidth = 3
//                }
//
//            } catch {
//                print("ERROR: not working")
//            }
//        }
//
//    }
}

extension OrderDrivingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0,
                                              bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}
