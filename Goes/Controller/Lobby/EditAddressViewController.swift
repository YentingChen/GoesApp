//
//  EditAddressViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/18.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GooglePlaces

class EditAddressViewController: UIViewController {
    
    typealias CompletionHandler = (Address?) -> Void
    var handler: CompletionHandler?
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBAction func dismiss(_ sender: Any) {
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
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
}

extension EditAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
    
     func showAlert(_ place: GMSPlace, handler: @escaping CompletionHandler) {
        let alertController = UIAlertController(title: "地址選擇",
                                                message: "確認地址為\n \((place.name)!)\n\((place.formattedAddress)!) ？", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(
            title: "確定",
            style: .default,
            handler: { (action) in
                
                let selectedAddress = Address(
                    placeID: (place.placeID)!,
                    placeLat: Double(place.coordinate.latitude),
                    placeLng: Double(place.coordinate.longitude),
                    placeName: (place.name)!,
                    placeformattedAddress: (place.formattedAddress)!)
                
                self.handler?(selectedAddress)
                
                self.dismiss(animated: true, completion: nil)
                
        })
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        showAlert(place, handler: { [weak self] adress in
            
            self?.handler!(adress)
        })
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
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
