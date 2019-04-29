//
//  LobbyViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Lottie

class LobbyViewController: UIViewController {
//4966-onboarding-car
    @IBOutlet weak var carView: UIView!
    
    
    let animationView = LOTAnimationView(name: "animation-w300-h300-2")
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animationView.frame = CGRect(x: 0, y: 0, width: carView.frame.width, height:  carView.frame.height)
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        animationView.animationSpeed = 1
        self.carView.addSubview(animationView)
        animationView.play()
    }

}
