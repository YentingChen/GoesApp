//
//  AdressHomeViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/18.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GooglePlaces

class AdressHomeViewController: AddressChooseViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func resultsController(
        _ resultsController: GMSAutocompleteResultsViewController,
        didAutocompleteWith place: GMSPlace) {
        
        super.resultsController(resultsController, didAutocompleteWith: place)
        
        selectedPlace = place
        
        category = "home"
        
    }
}
