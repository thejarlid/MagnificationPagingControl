//
//  MagnificationPagingControlIndicator.swift
//  Moleskine Paging Control
//
//  Created by Dilraj Devgun on 1/27/21.
//  Copyright © 2021 Dilraj Devgun. All rights reserved.
//
//  The indicator view for shich to place in the paging control. The indicator
//  displays a circle but can be configured to have an image instead. The circle
//  is filled on selection.
//
//  MIT License
//
//  Copyright (c) 2021 Dilraj Devgun
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

public class MagnificationPagingControlIndicator: UIView {
    
    
    /// Whether this indicator should be in the selected state
    public var isSelected: Bool = false {
        didSet {
            if isSelected {
                indicatorView?.backgroundColor = tintColor
                imageView?.tintColor = selectedImageTintColour != nil ? selectedImageTintColour : tintColor
            } else {
                indicatorView?.backgroundColor = .clear
                imageView?.tintColor = tintColor
            }
        }
    }
    
    
    /// the image to be displayed instead of an indicator shape
    public var image: UIImage? {
        didSet {
            if image == nil {
                imageView?.removeFromSuperview()
                indicatorView?.alpha = 1
            } else {
                createImageView()
            }
        }
    }
    
    
    /// the colour of the image in the indicator when this indicator is selected
    public var selectedImageTintColour: UIColor? {
        didSet {
            if let tint = selectedImageTintColour, isSelected {
                imageView?.tintColor = tint
            }
        }
    }
    
    
    /// tint colour of the indicator
    public override var tintColor: UIColor! {
        didSet {
            indicatorView?.layer.borderColor = tintColor.cgColor
            if isSelected {
                indicatorView?.backgroundColor = tintColor
                imageView?.tintColor = selectedImageTintColour == nil ? tintColor : selectedImageTintColour
            } else {
                imageView?.tintColor = tintColor
            }
        }
    }
    
    /// the border width of the indicator
    public var borderWidth: CGFloat = 1.5 {
        didSet {
            indicatorView?.layer.borderWidth = borderWidth
        }
    }
    
    internal var indicatorView:         UIView?             // subview that contains the style of the indicator shape
    internal var imageView:             UIImageView?        // subview that contains the indicator image if one is present
    private var completedInitialSetup:  Bool = false        // flag indicating whether the initial setup has been done
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if !completedInitialSetup {
            setup()
            completedInitialSetup = true
        }
        indicatorLayoutSubviews()
    }
    
    
    /// Sets up the subviews of this view creating the indicator
    /// and the associated image view if there is currently an imageview
    internal func setup() {
        createIndicatorView()
        createImageView()
    }
    
    
    internal func indicatorLayoutSubviews() {
        indicatorView?.layer.cornerRadius = frame.width/2
    }
    
    
    /// Creates the look of the indicator shape. This indicator's style is to be a circle that in the
    /// deselected state is simply the outline and when in the selected state the circle is filled with the
    /// tint colour
    internal func createIndicatorView() {
        indicatorView?.removeFromSuperview()
        
        indicatorView = UIView(frame: bounds)
        indicatorView?.layer.cornerRadius = frame.width/2
        indicatorView?.layer.borderWidth = borderWidth
        indicatorView?.layer.borderColor = tintColor.cgColor
        indicatorView?.backgroundColor = isSelected ? tintColor : .clear
        indicatorView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView!)
        
        NSLayoutConstraint.activate([
            indicatorView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            indicatorView!.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            indicatorView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            indicatorView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    
    /// Creates the internal image view if there is an image to present. The image will have the tint colour while
    /// deselected however when selected it will use the `selectedImageTintColour` if set otherwise it will remain the
    /// tint colour
    internal func createImageView() {
        guard let image = self.image else { return }
        
        indicatorView?.alpha = 0
        imageView?.removeFromSuperview()
        imageView = UIImageView()
        imageView?.image = image
        let newImage = imageView?.image?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5))
        imageView?.image = newImage
        imageView?.contentMode = .scaleToFill
        if isSelected && selectedImageTintColour != nil {
            imageView?.tintColor = selectedImageTintColour
        } else {
            imageView?.tintColor = tintColor
        }
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView!)
        NSLayoutConstraint.activate([
            imageView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView!.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
