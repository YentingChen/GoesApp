//
//  AddressChooseViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/5/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GooglePlaces

class AddressChooseViewController: UIViewController {
    
    var profileAddressVC: ProfileAdressViewController?
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var resultView: UITextView?
    
    var selectedPlace: GMSPlace?
    
    var category: String?
//
//    let alertManager = AlertManager()
//    
    @IBAction func dismissAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        
        view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        
        searchController?.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
    }
    
}

extension AddressChooseViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(
        _ resultsController: GMSAutocompleteResultsViewController,
        didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        selectedPlace = place
        
        guard let uid = UserDefaults.standard.value(
            forKey: UserdefaultKey.memberUid.rawValue) as? String,
            uid != "" else {
            return
        }
        
        let alertMessage = String.addressChangeMessage(
            
            placeName: selectedPlace?.name ?? "",
            
            placeFormatted: selectedPlace?.formattedAddress ?? "")
        
        AlertManager.share.showAlert(
            
            title: AlertTitleName.addressChanged.rawValue,
            
            message: alertMessage,
            
            viewController: self, typeOfAction: 2,
            
            okHandler: {
                
                FireBaseManager.share.updateAdress(
                    
                    myUid: uid,
                    
                    category: self.category ?? "",
                    
                    placeName: self.selectedPlace?.name ?? "",
                    
                    placeLng: self.selectedPlace?.coordinate.longitude ?? 0.0,
                    
                    placeLat: self.selectedPlace?.coordinate.latitude ?? 0.0,
                    
                    placeID: self.selectedPlace?.placeID ?? "",
                    
                    placeformattedAddress: self.selectedPlace?.formattedAddress ?? "",
                    
                    completionHandler: {
                        
                        self.profileAddressVC?.loadAdressInfoFromDB()
                        self.dismiss(animated: true, completion: nil)
                        
                })
        },
            cancelHandler: {
                
        })
        
    }
    
    func resultsController(
        _ resultsController: GMSAutocompleteResultsViewController,
        didFailAutocompleteWithError error: Error) {
        
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(
        forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(
        forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
