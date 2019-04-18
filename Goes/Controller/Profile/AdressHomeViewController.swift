//
//  AdressHomeViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/18.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GooglePlaces

class AdressHomeViewController: UIViewController {
    
    var profileAddressVC: ProfileAdressViewController?
    
    let personalDataManager = PersonalDataManager()
    let firebaseManager = FireBaseManager()
    var myProfile: MyProfile?
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalDataManager.getPersonalData(completionHandler: { [weak self]  (myProfile, error) in
               self?.myProfile = myProfile
        })
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
}

extension AdressHomeViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        let alertController = UIAlertController(title: "編輯地址",
                                                message: "地址編輯為 \((place.name)!) ？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(
            title: "確定",
            style: .default,
            handler: { (action) in
            
            self.firebaseManager.updateAdress(
                myUid: (self.myProfile?.userID)!,
                category: "home",
                placeName: (place.name)!,
                placeLng: Double(place.coordinate.latitude),
                placeLat: Double(place.coordinate.longitude),
                placeID: place.placeID!) {
                
                    print("hi")
            }
                
            self.profileAddressVC?.loadAdressInfoFromDB()
            self.dismiss(animated: true, completion: nil)
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){

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
