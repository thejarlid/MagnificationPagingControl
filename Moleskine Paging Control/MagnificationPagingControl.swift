//
//  MagnificationPagingControl.swift
//  Moleskine Paging Control
//
//  Created by Dilraj Devgun on 12/20/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//
//  A control that display's a vertical series of dots which the
//  user can then pan over and a magnification and selection effect
//  is created.
//
//  MIT License
//
//  Copyright (c) 2017 Dilraj Devgun
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit


protocol MagnificationPagingControlDataSource: class {

    /// Called when the colour of the dot at an index is needed
    ///
    /// - Parameter index: the index that the colour is needed for
    /// - returns: the colour for the requested index
    func colourForDotAtIndex(index:Int) -> UIColor
    
    
    /// Called when setting up the view at a provided index that the user has
    /// defined to be of MagnificationPagingControlItemType.icon
    ///
    /// - Parameter index: the index that the image is queried for, nil if no speical icon wanted
    /// - returns: the image to be used for the item at the provided index
    func indicatorImage(for index:Int) -> UIImage?
}


protocol MagnificationPagingControlDelegate: class {
    
    ///  Called when the user first makes contact with the control
    ///
    /// - Parameter point: The point in the control's coodinate space that the user pressed
    func touchDownInPageControl(point:CGPoint)
    
    
    /// Called when the touch in the control was cancelled
    func touchCancelledInPageControl()
    
    
    /// Called when the touch in the control ended
    func touchEndedInPageControl()
    
    
    /// Called when the touch in the control failed
    func touchFailedInPageControl()
    
    
    /// Called when the user changes the index of the control
    ///
    /// - Parameter index: the current index of the control
    func pageControlChangedToIndex(index:Int)
}


class MagnificationPagingControl: UIView {
    
    weak var delegate:          MagnificationPagingControlDelegate?         // page control's delegate for which to forward notifications to
    weak var dataSource:        MagnificationPagingControlDataSource?       // page control's data source which is used to define how to layout the view
    public var useHaptics:      Bool = true                                 // whether haptics should be used on the page control
    private var circles:        [MagnificationPagingControlIndicator] = []  // List of indicators ordered by page index
    private var generator:      UISelectionFeedbackGenerator?               // feedback generator to proivde haptic feedback on page change
    private var originalFrame:  CGRect!                                     // original frame of this view which is used for how layouts should be
    private var needsSetup:     Bool = false                                // whether the indicators need updating and to be reconstructed
    
    /// the current index that the page control is set to
    public private(set) var currentPage:   Int = -1 {
        didSet {
            // do some work
        }
    }
    
    
    /// the number of pages this paging control should display
    private var numberOfPages:  Int = 0 {
        didSet {
            // do some work and reset control
            
        }
    }
    
    
    /// The dimensions of the indicator frame. Indicators are square and so this
    /// corresponds to both the width and height of an indicator
    private var indicatorDimension: CGFloat = 8 {
        didSet {
            
        }
    }
    
    
    /// Padding space between indicators
    private var padding:  CGFloat! = 7 {
        didSet {
            
        }
    }
    
    
    /// Flag indicating whether the control should hide itself when only one page is active
    @IBInspectable open var hidesForSinglePage: Bool = false {
        didSet {
        
        }
    }
    
    
    /// The border width of the indicators
    public var indicatorBorderWidth: CGFloat = 1.5 {
        didSet {
            
        }
    }
    
    
    /// The tint colour for all indicators
    override open var tintColor: UIColor! {
        didSet {
            tintColors = [UIColor](repeating: tintColor, count: numberOfPages)
        }
    }
    
    
    /// The tint colour for each indicator if it is wanted that each indicator has a separate colour
    open var tintColors: [UIColor] = [] {
        didSet {
            guard tintColors.count == numberOfPages else {
                fatalError("The number of tint colors needs to be the same as the number of page")
            }
            // setup all indicators with this tint
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalFrame = frame
    }


    convenience init(frame:CGRect, numPages:Int, dimension:CGFloat) {
        self.init(frame: frame)
        numberOfPages = numPages
        indicatorDimension = dimension
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.originalFrame = self.frame
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        if !needsSetup {
            self.setup()
            needsSetup = true
        }
    }


    private func setup() {
        // sets up size for the circles to fit numDots within the frame
//        circleDiameter = overrideDiameter == nil ? min(max((self.originalFrame.height * 0.5)/CGFloat(numDots), 7), 12) : overrideDiameter
//        circleSpacing = min((self.originalFrame.height * 0.5)/CGFloat(numDots-1), 6.8)
//        // creates the gesture recognizer used to respond to a user's touch in the control space
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTouchInContainer(gesture:)))
//        gesture.minimumPressDuration = 0
//        gesture.numberOfTouchesRequired = 1
//        self.addGestureRecognizer(gesture)
//
//        setupInitialCircles()
    }
//
//
//    func reloadColours() {
//        if !initialSetup {
//            return
//        }
//        for i in 0..<numDots {
//            var colour = UIColor.orange
//            if let d = self.delegate {
//                colour = d.colourForDotAtIndex(index: i)
//            }
//            circles[i].backgroundColor = i == self.currentIndex ? colour : UIColor.clear
//            circles[i].layer.borderColor = colour.cgColor
//        }
//    }
//
//
//    /**
//     Sets up numDots dots within the frame vertically
//    */
//    private func setupInitialCircles() {
//        let halfFrameHeight = self.originalFrame.height/2
//        let circleStart = halfFrameHeight - ((self.circleDiameter * CGFloat(numDots)) + (CGFloat(numDots-1) * self.circleSpacing))/2
//
//        // changes the circle heights based on the distance from the dot
//        var runningHeight:CGFloat = circleStart
//
//        // make circles
//        for i in 0..<numDots {
//            let ratio: CGFloat = 1
//            let dimension = circleDiameter * ratio
//            let frame = CGRect(x: self.originalFrame.width/2 - circleDiameter/2, y: runningHeight, width: dimension, height: dimension)
//            let indicatorImage = delegate?.indicatorImage(for: i)
//            if let img = indicatorImage {
//                images[i] = img
//            }
//            let circle = UIView(frame: frame)
//            circle.layer.cornerRadius = dimension/2
//
//            var colour = UIColor.orange
//            if let d = self.delegate {
//                colour = d.colourForDotAtIndex(index: i)
//            }
//            if i == currentIndex {
//                circle.backgroundColor = colour
//            }
//            circle.layer.borderColor = colour.cgColor
//            circle.layer.borderWidth = 1.5
//            runningHeight += self.circleSpacing + dimension
//            self.addSubview(circle)
//            circles.append(circle)
//        }
//    }
//
//
//    /**
//     Responds to a user's touch based on the state that the gesture is currently in.
//     Alerts the delegate of any notable events they may want to listen to
//
//     - parameter gesture: the gesture sending the message
//    */
//    @objc
//    private func handleTouchInContainer(gesture:UIGestureRecognizer) {
//        switch gesture.state {
//        case .began:
//            generator = UISelectionFeedbackGenerator()
//            generator?.prepare()
//            draggedInControl(point: gesture.location(in: self))
//            if let d = self.delegate {
//                d.touchDownInPageControl(point: gesture.location(in: self))
//            }
//            break
//        case .cancelled:
//            generator = nil
//            resetCircles()
//            if let d = self.delegate {
//                d.touchCancelledInPageControl()
//            }
//            break
//        case .changed:
//            draggedInControl(point: gesture.location(in: self))
//            break
//        case .ended:
//            generator = nil
//            resetCircles()
//            if let d = self.delegate {
//                d.touchEndedInPageControl()
//            }
//            break
//        case.failed:
//            if let d = self.delegate {
//                d.touchFailedInPageControl()
//            }
//            resetCircles()
//            generator = nil
//            break
//        default:
//            generator = nil
//            resetCircles()
//            print("failed")
//        }
//    }
//
//
//    /**
//     Sets the current index of the control, filling the dot and alerting the
//     delegate of the index change
//
//     Ignores any value where index is negative or >= the total number of dots in the control
//
//     - parameter index: the index to change to
//    */
//    func setCurrentIndex(index:Int) {
//        if index < 0 || index >= self.numDots {
//            return
//        }
//        if let d = self.delegate {
//            d.pageControlChangedToIndex(index: index)
//        }
//        self.currentIndex = index
//        self.resetCircles()
//    }
//
//
//    /**
//     Getter for the current index of the control
//     - return: the currently selected index in the control, -1 if nothing is selected
//    */
//    func getCurrentIndex() -> Int {
//        return self.currentIndex
//    }
//
//
//    /**
//     Responds to the user dragging within the view. Handles circle growing and setting the current index if it changes.
//     Alerts the delegate of any index changes which may occur
//
//     - parameter point: the current position of the user's finger in the control's coordinate
//    */
//    private func draggedInControl(point:CGPoint) {
//        // finds the current dot that the user's finger is within bounds of
//        // first gets the start of the circles within the containing view
//        // then finds the displacement between the finger and the start and divides by the height of a circle's bounds
//        // then bounds that circle between 0 and numDots - 1
//        let halfFrameHeight = self.frame.height/2
//        let circleStart = halfFrameHeight - ((self.circleDiameter * CGFloat(numDots)) + (CGFloat(numDots-1) * self.circleSpacing))/2
//        let segmentHeight = self.circleDiameter + self.circleSpacing
//        let index = min(max(Int(max(0, (point.y - circleStart))/segmentHeight), 0), numDots-1)
//
//        // if there was a previously selected index that is different from the current index, we clear the fill
//        if currentIndex != -1 && currentIndex != index {
//            circles[currentIndex].backgroundColor = UIColor.clear
//        }
//
//        // set the fill on the currently selected dot
//        var colour = UIColor.orange
//        if let d = self.delegate {
//            colour = d.colourForDotAtIndex(index: index)
//        }
//        circles[index].backgroundColor = colour
//
//        // alert the user of an index change if one occurs
//        if index != currentIndex {
//            if useHaptics {
//                generator?.selectionChanged()
//            }
//            currentIndex = index
//            if let d = self.delegate {
//                d.pageControlChangedToIndex(index: currentIndex)
//            }
//        }
//
//        // changes the circle heights based on the distance from the dot
//        var runningHeight:CGFloat = circleStart
//        let maxDistance = self.circleDiameter*1.5 + self.circleSpacing
//        for i in 0..<numDots {
//            let distanceToCircle = min(abs((runningHeight + self.circleDiameter/2) - point.y), maxDistance)
//            let ratio = 1 + 2.5*(1  - (distanceToCircle/maxDistance))  // the 2.5 will control the size of the dot when it grows
//            let dimension = circleDiameter * ratio
//            let circle = circles[i]
//            let frame = CGRect(x: self.frame.width/2 - dimension/2, y: runningHeight, width: dimension, height: dimension)
//            circle.frame = frame
//            circle.layer.cornerRadius = dimension/2
//            runningHeight += self.circleSpacing + dimension
//        }
//    }
//
//
//    /**
//     Resets the circles back to their default position, leaving the currently selected dot filled
//    */
//    func resetCircles() {
//        if initialSetup {
//            let halfFrameHeight = self.originalFrame.height/2
//            let circleStart = halfFrameHeight - ((self.circleDiameter * CGFloat(numDots)) + (CGFloat(numDots-1) * self.circleSpacing))/2
//
//            // changes the circle heights based on the distance from the dot
//            var runningHeight:CGFloat = circleStart
//            for i in 0..<numDots {
//                let ratio: CGFloat = 1
//                let dimension = circleDiameter * ratio
//                let circle = circles[i]
//                let frame = CGRect(x: self.frame.width/2 - dimension/2, y: runningHeight, width: dimension, height: dimension)
//                circle.frame = frame
//                circle.layer.cornerRadius = dimension/2
//                runningHeight += self.circleSpacing + dimension
//            }
//        }
//    }
}
