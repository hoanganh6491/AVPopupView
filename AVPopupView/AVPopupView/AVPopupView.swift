//
//  AVPopupView.swift
//  AVPopupView
//
//  Created by  on 10/30/15.
//  Copyright © 2015 KZ. All rights reserved.
//

import UIKit

protocol AVPopupViewDelegate {
    func btnDismissCallback()
}

class AVPopupView: UIView {

    @IBOutlet weak var viewContentView: UIView!
    @IBOutlet weak var btnDismiss: UIButton!
    
    var delegate : AVPopupViewDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func btnDismissDidTap(sender: AnyObject) {
        self.delegate?.btnDismissCallback()
    }
}
