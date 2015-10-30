//
//  AVPopupViewController.swift
//  AVPopupView
//
//  Created by  on 10/30/15.
//  Copyright © 2015 KZ. All rights reserved.
//

import UIKit

let AVPopupViewMaxSize : CGFloat  = 0.9

protocol AVPopupViewControllerDelegate {
    //TODO: Adding more protocol matching with app feature - if needed
    func popupViewDidCallBack (object : AnyObject)
}

class AVPopupViewController : UIView, AVPopupViewDelegate {
    
    //views
    var containerView : UIView!
    var viewBlurView : FXBlurView!
    var viewBackgroundColor : UIView!
    
    //data
    var delegate : AVPopupViewControllerDelegate?
    
    let constantHeightMultiple : CGFloat = 0.8
    let constantWidthMultiple : CGFloat = 0.8
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    class func initWithNib(nibName: String, classBundle: NSBundle) -> AVPopupViewController {
        let popup : AVPopupViewController = AVPopupViewController()
        popup.setupViewWithNib(nibName, classBundle: classBundle)
        return popup
    }
    
    //MATK - View Cycle
    override class func initialize() {
        super.initialize()
    }
    
    override init(frame: CGRect) {
        let rect = UIScreen.mainScreen().bounds
        super.init(frame: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //setup view with nib - class bundle
    func setupViewWithNib (nibName: String, classBundle : NSBundle) {
        containerView = loadViewFromNib(nibName, classBundle: classBundle)
        self.addSubview(containerView)
    }
    
    //MARK - View Utils
    //loading view from nib - class bundle
    func loadViewFromNib(nibName: String, classBundle : NSBundle) -> UIView
    {
        let nib = UINib(nibName: nibName, bundle: classBundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! AVPopupView
        view.delegate = self
        view.layoutIfNeeded()
        
        let newRect = calculatingViewFrame(self.frame, sourceFrame: view.viewContentView.frame)
        view.frame = newRect
        view.center = CGPointMake(self.center.x, self.center.y - self.frame.size.height)
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        
        return view
    }
    
    //MARK - View Effect
    //re-calculating view frame
    func calculatingViewFrame (viewFrame: CGRect, sourceFrame: CGRect) -> CGRect {
        var newRect : CGRect = CGRectZero
        var transformWidthValue : CGFloat = 1
        var transformHeightValue : CGFloat = 1
        var heightValue : CGFloat = sourceFrame.height
        var widthValue : CGFloat = sourceFrame.width
        
        if sourceFrame.height >= (viewFrame.height * constantHeightMultiple) {
            transformHeightValue = AVPopupViewMaxSize
            heightValue = viewFrame.height
        }
        
        if sourceFrame.width >= (viewFrame.width * constantWidthMultiple) {
            transformWidthValue = AVPopupViewMaxSize
            widthValue = viewFrame.width
        }
        
        let transform = CGAffineTransformMake(transformWidthValue, 0, 0, transformHeightValue, 0, 0)
        newRect = CGRectApplyAffineTransform(CGRectMake(0, 0, widthValue, heightValue), transform)
        
        return newRect
    }
    
    //init background color trigger view
    func initBackgroundColorTriggerView () {
        viewBackgroundColor = UIView(frame: self.frame)
        viewBackgroundColor.backgroundColor = UIColor.darkGrayColor()
        viewBackgroundColor.alpha = 0.3
        viewBackgroundColor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissView")))
    }
    
    //init blur effect view
    func initBlurView () -> UIView {
        viewBlurView = FXBlurView(frame: UIScreen.mainScreen().bounds)
        viewBlurView.tintColor = UIColor.darkGrayColor()
        viewBlurView.blurRadius = 15.0
        return viewBlurView
    }
    
    //showing view function
    func show() {
        let mainWindow = UIApplication.sharedApplication().delegate?.window
        self.frame = UIScreen.mainScreen().bounds
        
        mainWindow!!.addSubview(initBlurView())
        
        mainWindow!!.addSubview(self)
        
        UIView.animateWithDuration(0.2, delay: 0, options: .AllowAnimatedContent, animations: { () -> Void in
            self.containerView.center = self.center
            }, completion: { (isCompleted) -> Void in
                
        })
    }
    
    //dismiss function
    func dismissView () {
        UIView.animateWithDuration(0.2, delay: 0, options: .AllowAnimatedContent, animations: { () -> Void in
            self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height)
            }, completion: { (isCompleted) -> Void in
                
        })
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewBlurView.alpha = 0.0
            }) { (isCompleted) -> Void in
                self.removeFromSuperview()
                self.viewBlurView.removeFromSuperview()
        }
    }
    
    func dismissViewWithObject (object: AnyObject) {
        UIView.animateWithDuration(0.2, delay: 0, options: .AllowAnimatedContent, animations: { () -> Void in
            self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height)
            }, completion: { (isCompleted) -> Void in
                
        })
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewBlurView.alpha = 0.0
            }) { (isCompleted) -> Void in
                self.removeFromSuperview()
                self.viewBlurView.removeFromSuperview()
                self.delegate?.popupViewDidCallBack(object)
        }
    }
    
    //MARK - AVPopupView Delegate
    func btnDismissCallback () {
        dismissView()
    }

}
