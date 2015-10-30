//
//  ViewController.swift
//  AVPopupView
//
//  Created by  on 10/30/15.
//  Copyright © 2015 KZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AVPopupViewControllerDelegate {

    
    @IBOutlet weak var btnShowPopup: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - Button
    
    @IBAction func btnShowPopupDidTap(sender: AnyObject) {
        let popup = AVPopupViewController.initWithNib("AVPopupView", classBundle: NSBundle(forClass: AVPopupView.classForCoder()))
        popup.delegate = self
        popup.show()
    }
 
    //MARK: - Popup View - Delegate
    func popupViewDidCallBack(object: AnyObject) {
        print("did call back")
    }
}

