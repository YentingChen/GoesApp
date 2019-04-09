//
//  OrderAnswerRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/9.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen

class OrderAnswerRequestViewController: UIViewController, MTSlideToOpenDelegate {
    @IBOutlet weak var slideButtonView: UIView!
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        let alertController = UIAlertController(title: "", message: "Done!", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (action) in
           self.navigationController?.popViewController(animated: true)
//            sender.resetStateWithAnimation(false)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    lazy var slideToOpen: MTSlideToOpenView = {
//        let slide = MTSlideToOpenView(frame: self.slideButtonView.frame)
        let slide = MTSlideToOpenView(frame: CGRect(x: 0, y: 0, width: self.slideButtonView.frame.width, height: self.slideButtonView.frame.height))
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadious = 20
        slide.thumbnailViewLeadingDistance = 10
        slide.thumnailImageView.backgroundColor = UIColor(red:109/255, green:203/255, blue:224/255, alpha:1.0)
        slide.draggedView.backgroundColor = UIColor(red:109/255, green:203/255, blue:224/255, alpha:1.0)
        
        slide.delegate = self
        slide.thumnailImageView.image = UIImage(named: "Images_24x_Arrow_Normal")
        slide.defaultLabelText = "Accept"
        
            
        
        slide.sliderHolderView.backgroundColor = UIColor(red:109/255, green:203/255, blue:224/255, alpha:0.3)
    
        return slide
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.slideButtonView.addSubview(slideToOpen)
        
//        self.view.addSubview(slideToOpen)
        
    }
    

    

}
