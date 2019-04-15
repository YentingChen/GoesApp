//
//  ProfileAdressViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class ProfileAdressViewController: UIViewController {
    var db = Firestore.firestore()
    var placeName = String()
    var placeLatitude = String()
    var placeLongtitude = String()
    var selectItem = ""

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfilePersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "profilePersonalTableViewCell")

    }

}

extension ProfileAdressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = ["住家", "公司", "常用"]
        let content = ["台北市信義區吳興街300號", "台北市信義區基隆路一段180號", "台北市大安區羅斯福路四段1號"]
        let image = ["home_icon_hollow_24x", "work_icon_hollow_24x", "star_icon_hollow_24x"]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profilePersonalTableViewCell", for: indexPath) as? ProfilePersonalTableViewCell else { return UITableViewCell() }
        cell.cellTitle.text = title[indexPath.row]
        cell.cellContent.text = content[indexPath.row]
        cell.cellImageView.image = UIImage(named: image[indexPath.row] )

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        self.selectItem = "home"
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
//        performSegue(withIdentifier: "toEditAressView", sender: self)
    }
    
    func addAdress(item: String) {
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.value(forKey: "uid") as? String {
            db.collection("users").document(userID).collection("address").document(item).setData([
                "placeName": self.placeName,
                "placeLat": self.placeLatitude,
                "placeLong": self.placeLatitude])
//            db.collection("users").document(userID).collection("address").document(item).updateData([
//                "placeName": self.placeName,
//                "placeLat": self.placeLatitude,
//                "placeLong": self.placeLatitude])
        }
    }
}

extension ProfileAdressViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if self.selectItem == "home" {
            placeLatitude = String(place.coordinate.latitude)
            placeLongtitude = String(place.coordinate.longitude)
            placeName = String(describing: place.name)
            addAdress(item: "home")
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
