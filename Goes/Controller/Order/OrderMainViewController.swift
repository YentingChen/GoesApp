//
//  OrderMainViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderMainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.addUnderlineForSelectedSegment()
        scrollView.delegate = self
    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        segmentedControl.changeUnderlinePosition()
        if sender.selectedSegmentIndex == 0 {
            scrollView.contentOffset.x = 0
        }

        if sender.selectedSegmentIndex == 1 {
            scrollView.contentOffset.x = scrollView.frame.size.width
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

    }

}

extension OrderMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeBtnView()
    }
}
