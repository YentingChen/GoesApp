//
//  LobbyMapViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/3.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LobbyMapViewController: UIViewController {
    
    var personalDataManager = PersonalDataManager.share
    var firebaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var homeAddress: Address?
    var workAddress: Address?
    var favoriteAddress: Address?
    var editAddressVC: EditAddressViewController?
    var selectedLocation: Address?
    var tempSelectedLocation: Address?
    
    @IBOutlet weak var addressBtn: UIButton! {
        didSet {
            
            self.addressBtn.contentHorizontalAlignment = .left
             self.addressBtn.titleLabel?.lineBreakMode = .byClipping
            
        }
    }
    
    @IBOutlet weak var adressSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func adressModeChosen(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            addressBtn.setTitle(self.tempSelectedLocation?.placeName, for: .normal)
            selectedLocation = self.tempSelectedLocation

        case 1:
            addressBtn.setTitle(self.homeAddress?.placeName, for: .normal)
            
            selectedLocation = self.homeAddress
            
        case 2:
            addressBtn.setTitle(self.workAddress?.placeName, for: .normal)
            
            selectedLocation = self.workAddress

        case 3:
            addressBtn.setTitle(self.favoriteAddress?.placeName, for: .normal)
            
            selectedLocation = self.favoriteAddress

        default: return
            
        }
        
    }
    
    func setCamera(lat: Double, lag: Double) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lag , zoom: 16)
        
        self.mapView.animate(to: camera)
    }
   
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
        self.navigationController?.dismiss(animated: false, completion: nil)
        
        present(LobbyViewController(), animated: false, completion: nil)
        
    }
    
    @IBAction func mylocationBtn(_ sender: Any) {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            // Disable location features
            showAlert(title: "請先設定位置權限", message: "前往設定頁面確認位置權限", actionNumber: 2) {
                self.toSettingPage()
            }
            
        case .authorizedWhenInUse:
            // Enable basic location features
            guard let lat = self.mapView.myLocation?.coordinate.latitude,
                let lng = self.mapView.myLocation?.coordinate.longitude else { return }
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 16)
            
            self.mapView.animate(to: camera)
            
        case .authorizedAlways:
            // Enable any of your app's location features
            guard let lat = self.mapView.myLocation?.coordinate.latitude,
                let lng = self.mapView.myLocation?.coordinate.longitude else { return }
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 16)
            
            self.mapView.animate(to: camera)
        }
        
    }

    @IBAction func addressBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "toEditAddressVC", sender: self)
        
    }
    
    func showAlert(title: String, message: String, actionNumber: Int, completeionHandler: @escaping () ->Void) {
        
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        
        if actionNumber == 1 {
            
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
           
            
        }
        
        if actionNumber == 2 {
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                
                completeionHandler()
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
        }
    
        self.present(alertController, animated: true, completion: nil)
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
    
    private let locationManager = CLLocationManager()

    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {

        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, _ in
            
            self.addressBtn.unlock()

            guard let address = response?.firstResult(), let lines = address.lines else { return }
            
            self.selectedLocation = Address(
                placeID: "",
                placeLat: Double(address.coordinate.latitude),
                placeLng: Double(address.coordinate.longitude),
                placeName: address.lines![0],
                placeformattedAddress: address.lines![0])
            
            self.tempSelectedLocation = Address(
                placeID: "",
                placeLat: Double(address.coordinate.latitude),
                placeLng: Double(address.coordinate.longitude),
                placeName: address.lines![0],
                placeformattedAddress: address.lines![0])
            
            self.addressBtn.setTitle(lines.joined(separator: "\n"), for: .normal)
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func toTimePage(_ sender: Any) {
        
        guard self.selectedLocation != nil else {
            showAlert(title: "請先選擇位置", message:  "請先選擇位置", actionNumber: 1) {
                
            }
            return }
        
        performSegue(withIdentifier: "toTimePage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.isMyLocationEnabled = true
        
        mapView.delegate = self

        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        loadAdressInfoFromDB()
        
    }
    
    func loadAdressInfoFromDB() {
        
        personalDataManager.getPersonalData { (myProfile, _) in
            
            self.myProfile = myProfile
            
            self.firebaseManager.queryAdress(
                myUid: (myProfile?.userID)!,
                category: "home",
                completionHandler: { (homeAddress) in
                self.homeAddress = homeAddress
            })
            
            self.firebaseManager.queryAdress(
                myUid: (myProfile?.userID)!,
                category: "work",
                completionHandler: { (workAddress) in
                self.workAddress = workAddress
            })
            
            self.firebaseManager.queryAdress(
                myUid: (myProfile?.userID)!,
                category: "favorite",
                completionHandler: { (favoriteAddress) in
                self.favoriteAddress = favoriteAddress
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditAddressVC" {
            
            if let destination = segue.destination as? EditAddressViewController {
                
                self.editAddressVC = destination
                
                self.editAddressVC?.handler = { (selectedAddress) in
                    
                    self.addressBtn.setTitle(selectedAddress?.placeName, for: .normal)
                    
                    self.selectedLocation = selectedAddress
                    
//                    let camera = GMSCameraPosition.camera(withLatitude: (selectedAddress?.placeLat)!, longitude: (selectedAddress?.placeLng)!, zoom: 16)
//
//                    self.mapView.animate(to: camera)
                    
                }
            }
            
        }
        
        if segue.identifier == "toTimePage" {
            
            if let destination = segue.destination as? LobbyTimeViewController {
                
                destination.selectedLocation = self.selectedLocation
                
            }
        }
    }

}

extension LobbyMapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }

        locationManager.startUpdatingLocation()

        mapView.isMyLocationEnabled = true

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }

        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)

        locationManager.stopUpdatingLocation()
        
    }
}

// MARK: - GMSMapViewDelegate
extension LobbyMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        reverseGeocodeCoordinate(position.target)
        
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0,
                                            bottom: 85, right: 0)
        
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        addressBtn.setTitle("", for: .normal)

        self.adressSegmentedControl.selectedSegmentIndex = 0
        
        addressBtn.lock()

    }

}
