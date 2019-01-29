//
//  ScrollingLabel.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum LimitedAlignment {
    case left
    case center
    case right
}

final class ScrollingValueView:UIView {
    
    @IBOutlet var contentView:UIView!
    
    @IBOutlet var labels:[VerticalCharacterLabel] = []
    @IBOutlet var labelMaskView:UIView!
    
    var scrollingValueController:ScrollingValueUIController!
    var scrollingLabelAnimator:VerticalScrollingAnimator!
    
    var value:Int = 0 {
        didSet {
            scrollingValueController.value = value
        }
    }
    
    var labelsFontSize:CGFloat = 100 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var labelsAlignment:LimitedAlignment = .center {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        //Load from xib
        Bundle.main.loadNibNamed("ScrollingValueView", owner: self, options: nil)
        
        if (labels.count == 0 || labelMaskView == nil || contentView == nil) {
            fatalError("Missing references to one or more view components. Did you forget to hook up the IBOutlets?")
        }
        
        contentView.frame = bounds
        addSubview(contentView)
        
        scrollingValueController = ScrollingValueUIController(labels: labels)
        scrollingLabelAnimator = VerticalScrollingAnimator()
        
        scrollingLabelAnimator.delegate = scrollingValueController
        
        for label in labels {
            label.animator = scrollingLabelAnimator
        }
        
        self.backgroundColor = UIColor.clear
        self.layer.mask = labelMaskView.layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var maskViewFrame:CGRect = labelMaskView.frame
        
        for (i,label) in labels.enumerated() {
            label.font = UIFont(name: label.font.fontName, size: labelsFontSize)
            label.frame = VerticalCharacterLabel.frameToFitFont(label: label, characterHeight: 3)
            label.center.y = self.contentView.center.y
            
            let labelWidth = label.frame.size.width
            
            var labelCenterOffset:CGFloat = -(labelWidth * CGFloat(labels.count))/2 + contentView.center.x
            label.textAlignment = .center
            
            switch (labelsAlignment) {
            case .left: labelCenterOffset = contentView.frame.origin.x; label.textAlignment = .left
                break
            case .right: labelCenterOffset = contentView.frame.origin.x + contentView.frame.size.width - (labelWidth * CGFloat(labels.count)); label.textAlignment = .right
                break
            default:
                break
            }
            
            label.center.x = CGFloat(i) * (labelWidth) + labelCenterOffset + labelWidth/2
            maskViewFrame.size.height = label.font.lineHeight * 0.8
        }
        
        labelMaskView.frame = maskViewFrame
        labelMaskView.center.y = contentView.center.y
    }
}
