//
//  OrderAnswerRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class OrderAnswerRequestViewController: UIViewController, MTSlideToOpenDelegate {
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var arrivingTime: UILabel!
    
    @IBOutlet weak var slideButtonView: UIView!
    
    private let locationManager = CLLocationManager()
    var orderRequestVC: OrderRequestViewController?
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var order: OrderDetail?
    var rider: MyProfile?

    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        let alertController = UIAlertController(title: "", message: "Done!", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (_) in
        
            self.fireBaseManager.orderDeal(myUid: self.myProfile!.userID, friendUid: self.rider!.userID, orderID: (self.order?.orderID)!, completionHandler: {
                
                self.orderRequestVC?.myOrders = []
                self.orderRequestVC?.loadDataFromDB()
               
                self.navigationController?.popViewController(animated: true)
            })
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }

    lazy var slideToOpen: MTSlideToOpenView = {

        let slide = MTSlideToOpenView(
            frame: CGRect(x: 0, y: 0,
                          width: self.slideButtonView.frame.width,
                          height: self.slideButtonView.frame.height))
        
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadious = 20
        slide.thumbnailViewLeadingDistance = 10
        slide.thumnailImageView.backgroundColor = UIColor(red: 109/255, green: 203/255, blue: 224/255, alpha: 1.0)
        slide.draggedView.backgroundColor = UIColor(red: 109/255, green: 203/255, blue: 224/255, alpha: 1.0)

        slide.delegate = self
        slide.thumnailImageView.image = UIImage(named: "Images_24x_Arrow_Normal")
        slide.defaultLabelText = "Accept"

        slide.sliderHolderView.backgroundColor = UIColor(red: 109/255, green: 203/255, blue: 224/255, alpha: 0.3)

        return slide
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMap.isMyLocationEnabled = true
        googleMap.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let year = order!.selectTimeYear
        let month = order!.selectTimeMonth
        let day = order!.selectTimeDay
        let time = order!.selectTimeTime

        self.slideButtonView.addSubview(slideToOpen)
        self.riderName.text = self.rider?.userName
        
        self.arrivingTime.text = "\(year)-\(month)-\(day) \(time)"
        
        self.locationAddress.text = order?.locationFormattedAddress
       
    }

}

extension OrderAnswerRequestViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        drawPath(location: location)
        
        locationManager.stopUpdatingLocation()
        
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
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.googleMap
                    polyline.strokeColor = UIColor.G1!
                    polyline.strokeWidth = 3
                }
                
            } catch {
                print("ERROR: not working")
            }
        }
        
    }
}

extension OrderAnswerRequestViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.googleMap.padding = UIEdgeInsets(top: 0, left: 0,
                                            bottom: 0, right: 0)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
}
