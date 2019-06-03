//
//  GoogleMapManager.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/18.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import GoogleMaps
import GooglePlaces

class GoogleMapManager: NSObject {
    
    static let share = GoogleMapManager()
    
    private override init() {}
    
    func fetchDirection(url: URL, completion: @escaping (Result<GoogleDirection, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    
                    completion( Result.failure(.domainError))
                    
                }
                
                return
                
            }
            
            do {
                
                let directionData = try JSONDecoder().decode(GoogleDirection.self, from: data)
                
                completion(Result.success(directionData))
                
            } catch {
                completion(Result.failure(.decoingError))
            }
            }.resume()
        
    }
    
    func getEstmatedTime(
        url: String,
        viewController: MapViewController,
        completionHandler: @escaping (String)
        -> Void) {
        
        alamofireAction(url: url) { (json) in
            let timeValue = json["routes"][0]["legs"][0]["duration"]["value"].rawValue as? Int
            if timeValue != nil {
                let current = Int(Date().timeIntervalSince1970) + timeValue!
                let dformatter = DateFormatter()
                let date = Date(timeIntervalSince1970: TimeInterval(current))
                dformatter.dateFormat = "HH:mm"
                let showEstimatedTime = dformatter.string(from: date)
                completionHandler(showEstimatedTime)
            } else {
                completionHandler(" -- : -- ")
            }
            
        }
        
    }

    func drawPath(url: String, viewController: MapViewController ) {
        
        alamofireAction(url: url) { (json) in
            
            let routes = json["routes"].arrayValue
            
            for route in routes {
                
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                
                let points = routeOverviewPolyline?["points"]?.stringValue
                
                let path = GMSPath.init(fromEncodedPath: points!)
                
                let polyline = GMSPolyline.init(path: path)
                
                polyline.map = viewController.orderDrivingView.mapView
                
                polyline.strokeColor = UIColor.R1!
                
                polyline.strokeWidth = 6
                
            }
        }

    }
    
    func setCamera(origin: Point, destination: Point, insets: UIEdgeInsets, viewController: MapViewController) {
        
        var region = GMSVisibleRegion()
        
        region.nearLeft = CLLocationCoordinate2D(latitude: origin.x, longitude: origin.y)
        
        region.farRight = CLLocationCoordinate2D(latitude: destination.x, longitude: destination.y)
        
        let bounds = GMSCoordinateBounds(coordinate: region.nearLeft, coordinate: region.farRight)
        
        guard let camera = viewController.orderDrivingView.mapView.camera(
            for: bounds,
            insets: insets) else { return }
        
        viewController.orderDrivingView.mapView.camera = camera
        
    }
    
    func setRiderMarker(position: Point, viewController: MapViewController) { 
        
        let dot = CLLocationCoordinate2D(latitude: position.x, longitude: position.y)
        
        let marker = GMSMarker(position: dot)
        
        marker.icon = UIImage(named: "Images_60x_Rider_Normal")
        
        marker.map = viewController.orderDrivingView.mapView
    }
    
    func getCoordinate(placeID: String, completionHandler: @escaping (Double, Double) -> Void) {
        
        let apiKey = "AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        
        let url = "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=\(placeID)&key=\(apiKey)"
        
        alamofireAction(url: url) { (json) in
            let latitute = json["result"]["geometry"]["location"]["lat"].numberValue
            let longtitute = json["result"]["geometry"]["location"]["lng"].numberValue
            completionHandler(Double(truncating: latitute),Double(truncating: longtitute))
        }

    }
    
    func alamofireAction(url: String, completionHandler: @escaping (JSON)->Void){
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            do {
              let json = try JSON(data: response.data!)
              try completionHandler(json)
                
            } catch {
                print("ERROR: not working")
            }
        }
        
    }
}
