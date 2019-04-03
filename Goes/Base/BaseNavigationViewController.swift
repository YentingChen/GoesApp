//
//  BaseNavigationViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class STNoUnderlineNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationBar.shadowImage = UIImage()
        
        self.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
        self.navigationBar.backIndicatorImage = UIImage.asset(.Icons_24px_Back02)
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage.asset(.Icons_24px_Back02)
//
//        let yourBackImage = UIImage(named: "back_button_image")
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        self.navigationController?.navigationBar.backItem?.title = "Custom"
    }
    
}
