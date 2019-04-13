//
//  ProfileMainViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileMainViewController: UIViewController {
    var profilePersonalVC = ProfilePersonalDataViewController()

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        segmentedControl.addUnderlineForSelectedSegment()
        segmentedControl.removeBorder()
       
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "SignUp")
                self.present(viewController, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func changeBtnView() {
        if scrollView.contentOffset.x == 0 {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.changeUnderlinePosition()

        }
        if scrollView.contentOffset.x == scrollView.frame.size.width {
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.changeUnderlinePosition()

        }

        if scrollView.contentOffset.x == scrollView.frame.size.width*2 {
            segmentedControl.selectedSegmentIndex = 2
            segmentedControl.changeUnderlinePosition()

        }

    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        segmentedControl.changeUnderlinePosition()
        if sender.selectedSegmentIndex == 0 {
            scrollView.contentOffset.x = 0
        }

        if sender.selectedSegmentIndex == 1 {
            scrollView.contentOffset.x = scrollView.frame.size.width
        }

        if sender.selectedSegmentIndex == 2 {
            scrollView.contentOffset.x = scrollView.frame.size.width*2
        }
    }

}

extension ProfileMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeBtnView()
    }

}
