//
//  ProfileHistoryDetailViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/26.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class ProfileHistoryDetailViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    
    var myProfile: MyProfile?
    var history: OrderDetail?
    
    var driver: MyProfile?
    var rider: MyProfile?

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var driverSetOffTime: UILabel!
    @IBOutlet weak var driverSetOffAddress: UILabel!
    @IBOutlet weak var completeTime: UILabel!
    @IBOutlet weak var selectedAddress: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let history = self.history else { return }
       
        showNames()
        
        self.driverSetOffTime.text =  String.formateTimeStamp(timeStamp: history.driverStartTime)
        
        self.completeTime.text = String.formateTimeStamp(timeStamp: history.completeTime)
        
        mapView.delegate = self
        
        self.selectedAddress.text = history.locationFormattedAddress
        
        self.estimatedTime.text = String.produceTime(order: history)
        
        drawPath()

    }
    
    func drawPath() {
        
        let rPosition = CLLocationCoordinate2D(latitude: (history?.selectedLat)!, longitude: (history?.selectedLng)!)
        let rMarker = GMSMarker(position: rPosition)
        rMarker.icon = UIImage(named: "Images_60x_Rider_Normal")
        
        let dPosition = CLLocationCoordinate2D(latitude: (history?.driverStartLat)!, longitude: (history?.driverLag)!)
        let dMarker = GMSMarker(position: dPosition)
        dMarker.icon = UIImage(named: "Images_60x_Driver_Normal")
        dMarker.map = self.mapView
        rMarker.map = self.mapView
        
        var region = GMSVisibleRegion()
        
        region.nearLeft = rPosition
        
        region.farRight = dPosition
        
        let bounds = GMSCoordinateBounds(
            coordinate: region.nearLeft,
            coordinate: region.farRight)
        
        guard let camera = self.mapView.camera(
            for: bounds,
            insets:UIEdgeInsets(top: 50, left: 100 , bottom: 50,  right: 100 )) else { return }
        
        self.mapView.camera = camera
        
        let origin = "\(Double(dPosition.latitude)),\(Double(dPosition.longitude))"
        let destination = "\(Double(rPosition.latitude)),\(Double(rPosition.longitude))"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                let startAddress = json["routes"][0]["legs"][0]["start_address"].stringValue
                
                self.driverSetOffAddress.text = startAddress
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.mapView
                    polyline.strokeColor = UIColor.R1!
                        
                    polyline.strokeWidth = 6
                }
                
            } catch {
                
            }
        }
        
    }
    
    func showNames() {
        
        guard let driverUid = self.history?.driverUid else { return }
        guard let riderUid = self.history?.riderUid else { return }
        
        self.fireBaseManager.queryUserInfo(userID: driverUid) { (driver) in
            guard let driver = driver else { return }
            self.driver = driver
            self.driverName.text = driver.userName
        }
        
        self.fireBaseManager.queryUserInfo(userID: riderUid) { (rider) in
            guard let rider = rider else { return }
            self.rider = rider
            self.riderName.text = rider.userName
        }
    }
 
}
extension ProfileHistoryDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else { return }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = false
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
        
    }
}

// MARK: - GMSMapViewDelegate
extension ProfileHistoryDetailViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }

}
