//
//  ViewController.swift
//  Moleskine Paging Control
//
//  Created by Dilraj Devgun on 12/20/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//
//  Demo ViewController showing how to construct a Magnification
//  Paging Control and how to respond to its delegate methods.
//  A MagnificationPagingControl can also be created using
//  a storyboard by dragging a UIView and changing the class
//
//    MIT License
//
//    Copyright (c) 2017 Dilraj Devgun
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import UIKit

class ViewController: UIViewController, MagnificationPagingControlDelegate, MagnificationPagingControlDataSource {
    
    var pagingControl:MagnificationPagingControl!
    var label:UILabel!          // displays the currently selected index of the control
    var startWidth:CGFloat!     // starting width of the control
    var startHeight:CGFloat!    // starting height of the control
    var colourSwitch:UISwitch!  // switch to change the colour of the app
    var creditLabel:UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // create the label in the center of the screen and the credit label in the bottom right hand corner
        label = UILabel(frame: self.view.frame)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 28)
        label.text = "0"
        
        creditLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        creditLabel.textAlignment = .right
        creditLabel.textColor = UIColor.black
        creditLabel.font = UIFont.systemFont(ofSize: 8)
        creditLabel.text = "made by Dilraj Devgun"
        creditLabel.sizeToFit()
        creditLabel.frame = CGRect(x: self.view.frame.width - creditLabel.frame.width - 8, y: (self.view.frame.height * 0.9) + 27,
                                   width: creditLabel.frame.width, height: creditLabel.frame.height)
        
        // makes the UISwitch in the bottom left hand corner
        colourSwitch = UISwitch()
        colourSwitch.onTintColor = UIColor.black
        colourSwitch.isOn = true
        colourSwitch.frame = CGRect(x: 10, y: self.view.frame.height * 0.9, width: 40, height: 30)
        colourSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        
        // sets up the control at the centre right side of the screen and sets the currently selected index to 0
        // setting the index is optional, default behaviour is nothing selected
        startWidth = self.view.frame.width*0.1
        startHeight = self.view.frame.height*0.15
        pagingControl = MagnificationPagingControl(frame: CGRect(origin: CGPoint(x: self.view.frame.width - startWidth, y: self.view.frame.height/2 - startHeight/2),
                                                                 size: CGSize(width: startWidth, height: startHeight)), numPages: 4)
        pagingControl.dataSource = self
        pagingControl.delegate = self
        
        // adds all the created views above to the ViewController's main view
        self.view.addSubview(creditLabel)
        self.view.addSubview(colourSwitch)
        self.view.addSubview(label)
        self.view.addSubview(pagingControl)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let frame = CGRect(x: self.view.frame.width - self.startWidth, y: self.view.frame.height/2 - self.pagingControl.frame.height/2,
                           width: self.pagingControl.frame.width, height: self.pagingControl.frame.height)
        self.pagingControl.frame = frame
    }
    

    /// Responds to the UISwitch changing its value
    ///
    /// - Parameter sender: The switch whose value changed
    @objc
    func switchChanged(sender:UISwitch) {
        var textColour = UIColor.black
        var backgroundColour = UIColor.white
        if !sender.isOn {
            textColour = UIColor.white
            backgroundColour = UIColor.black
        }
        self.view.backgroundColor = backgroundColour
        self.label.textColor = textColour
        self.creditLabel.textColor = textColour
    }
    
    
    // MARK: - MagnificationPagingControlDelegate
    
    
    func touchDownInPageControl(point: CGPoint) {
        // animates the control inwards to be more dynamic and so the user's finger doesn't cover the control
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1,
                       options: [.beginFromCurrentState], animations: {() in
            self.pagingControl.transform = CGAffineTransform(translationX: -self.startWidth * 1.5, y: 0)
        }, completion: nil)
            
    }
    
    
    func touchFailedInPageControl() {
        animateControlBack()
    }
    
    
    func touchEndedInPageControl() {
        animateControlBack()
    }
    
    
    func touchCancelledInPageControl() {
        animateControlBack()
    }

    
    /// Moves the control back into its starting position
    func animateControlBack() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1,
                       options: [.beginFromCurrentState], animations: {() in
            self.pagingControl.transform = .identity
        }, completion: nil)
    }
    
    
    func pageControlChangedToIndex(index: Int) {
        label.text = "\(index)"
    }

    
    func colourForIndicator(at index: Int) -> UIColor {
        return UIColor.orange
    }
    

    func indicatorImage(for index: Int) -> (UIImage?, UIColor?) {
        if index == 0 {
            return (UIImage(named: "inbox"), UIColor.black)
        }
        return (nil, nil)
    }
}

