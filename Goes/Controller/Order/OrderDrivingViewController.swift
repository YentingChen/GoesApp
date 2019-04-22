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
    
    private let locationManager = CLLocationManager()
    
    var orderRequestVC: OrderRequestViewController?
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?

    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var arrivingAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        self.arrivingAddress.text = self.order?.locationFormattedAddress
        self.riderName.text = self.rider?.userName
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
     func mylocation() {
        
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
            let lng = self.mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 16)
        self.mapView.animate(to: camera)
        
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
        
        drawPath(location: location)
        self.fireBaseManager.updateDriverLocation(
            orderID: (self.order?.orderID)!,
            lat: Double(location.coordinate.latitude),
            lag: Double(location.coordinate.longitude))
        
//        locationManager.stopUpdatingLocation()
        
    }
    
    func drawPath(location: CLLocation) {
        
        let origin = "\(self.order!.selectedLat),\(self.order!.selectedLng)"
        let destination = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                let timeTxt = json["routes"][0]["legs"][0]["duration"]["text"]
                let timeValue = json["routes"][0]["legs"][0]["duration"]["value"].rawValue as? Int
               print(timeValue)
                let current = Int(Date().timeIntervalSince1970) + timeValue!
                let dformatter = DateFormatter()
                let date = Date(timeIntervalSince1970: TimeInterval(current))
                dformatter.dateFormat = "HH:mm"
                self.estimateTime.text = dformatter.string(from: date)
                print("对应的日期时间：\(dformatter.string(from: date))")
            
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.mapView
                    polyline.strokeColor = UIColor.G1!
                    polyline.strokeWidth = 3
                }
                
            } catch {
                print("ERROR: not working")
            }
        }
        
    }
}

extension OrderDrivingViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0,
                                              bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}
