//
//  OrderRidingViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/23.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import Lottie

class OrderRidingViewController: BaseMapViewController {
    
    var orderMyRequestVC: OrderMyRequestViewController?
    var driverFirstLocation: CLLocationCoordinate2D?
    var completeTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        checkLocationAuth()
        
        guard let driver = self.driver else { return }
        guard driver.avatar != "" else { return }
        orderRrivingView.showAvatar(url: driver.avatar)
        
        showMarker(self.order)
        orderRrivingView.arrivingAddressLabel.text = order?.locationFormattedAddress
        orderRrivingView.driverName.text = driver.userName
        
        listenDriverLocation()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
    
        self.view.addGestureRecognizer(longPress)
       
    }
    
    fileprivate func listenDriverLocation() {
        
        guard let orederID = self.order?.orderID else { return }
        FireBaseManager.share.listenDriverLocation(orderID: orederID) { [weak self] order in
            
            self?.order = order
            
            self?.orderRrivingView.mapView.clear()
            
            self?.showMarker(order)
            
            if self?.driverFirstLocation == nil {
                
                self?.driverFirstLocation = CLLocationCoordinate2D(
                    latitude: (order?.driverLat)!,
                    longitude: (order?.driverLag)!)
                
                guard let driverFirstLocation = self?.driverFirstLocation else { return }
                
                var region = GMSVisibleRegion()
                
                region.nearLeft = CLLocationCoordinate2DMake((self?.order?.selectedLat)!, (self?.order?.selectedLng)!)
                
                region.farRight = driverFirstLocation
                
                let bounds = GMSCoordinateBounds(coordinate: region.nearLeft,coordinate: region.farRight)
                
                guard let camera = self?.orderRrivingView.mapView.camera(for: bounds, insets:UIEdgeInsets(top: 50, left: 100, bottom: 50, right: 100)) else { return }
                
                self?.getArrivingTime(location: driverFirstLocation)
                
                self?.orderRrivingView.mapView.camera = camera
                
            }
            
        }
    }
    
    fileprivate func showMarker(_ order: OrderDetail?) {
        
        guard let order = order else { return }
        let driverLocation = CLLocationCoordinate2D(latitude: order.driverLat, longitude: order.driverLag)
        let driverMarker = GMSMarker(position: driverLocation)
        driverMarker.icon = UIImage(named: "Images_60x_Driver_Normal")
        driverMarker.map = orderRrivingView.mapView
        
        let riderLocation = CLLocationCoordinate2D(latitude: order.selectedLat, longitude: order.selectedLng)
        let riderMarker = GMSMarker(position: riderLocation)
        riderMarker.icon = UIImage(named: "Images_60x_Rider_Normal")
        riderMarker.map = orderRrivingView.mapView
    }
    
    func getArrivingTime(location: CLLocationCoordinate2D) {
        
        guard let order = self.order else { return }
        
        let origin = "\(order.selectedLat),\(order.selectedLng)"
        let destination = "\(location.latitude),\(location.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAw1nm850dZdGXNXekQXf0_TK846oFKX84"
        
        GoogleMapManager.share.fetchDirection(url: URL(string: url)!) { result in
            switch result {
            case .success(let posts):
                let timeValue = posts.routes[0].legs[0].duration.value
                if timeValue != nil {
                    
                    let current = Int(Date().timeIntervalSince1970) + timeValue
                    let dformatter = DateFormatter()
                    let date = Date(timeIntervalSince1970: TimeInterval(current))
                    dformatter.dateFormat = "HH:mm"
                    self.orderRrivingView.estimatedTime.text = dformatter.string(from: date)
                    
                } else {
                    self.orderRrivingView.estimatedTime.text = " -- : -- "
                }
                
                
            case .failure:
                print("Failed")
            }
        }
        
//        Alamofire.request(url).responseJSON { response in
//            
//            do {
//                
//                let json = try JSON(data: response.data!)
//                let timeValue = json["routes"][0]["legs"][0]["duration"]["value"].rawValue as? Int
//                if timeValue != nil {
//                    
//                    let current = Int(Date().timeIntervalSince1970) + timeValue!
//                    let dformatter = DateFormatter()
//                    let date = Date(timeIntervalSince1970: TimeInterval(current))
//                    dformatter.dateFormat = "HH:mm"
//                    self.orderRrivingView.estimatedTime.text = dformatter.string(from: date)
//                    
//                } else {
//                    self.orderRrivingView.estimatedTime.text = " -- : -- "
//                }
//                
//            } catch {
//                print("ERROR: not working")
//            }
//        }
        
    }
    
    func nowTimeStamp() {
        let now = Date()
        self.completeTime = Int(now.timeIntervalSince1970)
        
    }
    
    func toSettingPage() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func showAlert(title: String, message: String, completeionHandler: @escaping () ->Void) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            
            completeionHandler()
            
        })
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLocationAuth() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            // Disable location features
            
            showAlert(title: "請先設定位置權限",
                      message: "前往 設定/隱私權/定位服務/允許取用位置，選取 “永遠”或是 “使用 App 期間”，否則將無法使用該功能 ") {
                        self.toSettingPage()
                        self.navigationController?.popViewController(animated: false)
            }
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable any of your app's location features
            return
            
        }
    }
    
    @IBAction func callBtn(_ sender: Any) {
        guard let riderPhone = driver?.phoneNumber else {
            return
        }
        guard let number = URL(string: "tel://" + "\(riderPhone)") else {
            return
        }
        UIApplication.shared.open(number)
    }
    
    @objc func longPressAction(_ sender: UIGestureRecognizer) {

        let animationView = AnimationView(name: LottieFile.caseSuccessAnimationView.rawValue)
        let animationViewFrame = orderRrivingView.successfulImage.frame
        animationView.frame = CGRect(x: 0, y: 0, width: animationViewFrame.width, height:  animationViewFrame.height)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2
        
        orderRrivingView.successfulImage.addSubview(animationView)

        if sender.state == .ended {
           animationView.stop()
            print("ok")
            nowTimeStamp()

            FireBaseManager.share.orderComplete(
                myUid: self.myProfile?.userID ?? "" ,
                friendUid: self.driver?.userID ?? "",
                orderID: self.order?.orderID ?? "",
                completeTime: self.completeTime ?? 0,
                completionHandler: {

                    print("driver arrive")

                })

        }

        if sender.state == .began {
           animationView.play()

        }
       
    }

    override func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            checkLocationAuth()
            return }
        
        locationManager.startUpdatingLocation()
        
        orderRrivingView.mapView.isMyLocationEnabled = true
        orderRrivingView.mapView.settings.myLocationButton = true
       
    }

}
