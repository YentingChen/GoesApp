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

class LobbyFindMyFriendViewController: UIViewController, GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
//        let lat = 43.1561681
//        let lng = -75.8449946
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 10)
//        self.mapView.animate(to: camera)
//
//        let request = URLRequest(url: URL(string: "")!)
//        Alamofire.request(request)
//        drawPath()
    }
    
    func drawPath(location: CLLocation) {
        let origin = "\(25.075683),\(121.575379)"
        let destination = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyD_mMIHbDWkWE2p0c36ZjreWSIG1V4qmYE"

        Alamofire.request(url).responseJSON { response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.mapView
                }
                
            } catch {
                print("ERROR: not working")
            }
        }
        
    }

}

extension LobbyFindMyFriendViewController: CLLocationManagerDelegate {
    
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
        
        locationManager.stopUpdatingLocation()
        drawPath(location: location)
    }
}
