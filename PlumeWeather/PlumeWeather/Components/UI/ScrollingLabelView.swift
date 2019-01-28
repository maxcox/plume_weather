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

enum ScrollingLabelAlignment {
    case left
    case center
    case right
}

final class ScrollingLabelView:UIView, ScrollingCharacterDelegate {
    
    @IBOutlet var contentView:UIView!
    
    @IBOutlet var labels:[ScrollingCharacterLabel] = []
    @IBOutlet var labelMaskView:UIView!
    
    var labelsFontSize:CGFloat = 100 {
        didSet {
            updateLabels(newFontSize: labelsFontSize)
        }
    }
    
    var labelsAlignment:ScrollingLabelAlignment = .center {
        didSet {
            layoutSubviews()
        }
    }
    
    var value:Int = 0 {
        didSet {
            checkTextNeedsUpdate()
        }
    }
    
    private var currentValue:Int = 0 {
        didSet {
            text = String(currentValue)
        }
    }
    
    private var text:String = "  0" {
        didSet {
            updateLabels(with: labelValues(for: text))
        }
    }
    
    private var targetScrollSpeed:Double = 1
    private var currentScrollSpeed:Double = 1
    
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
        Bundle.main.loadNibNamed("ScrollingLabelView", owner: self, options: nil)
        
        if (labels.count == 0 || labelMaskView == nil || contentView == nil) {
            fatalError("Missing references to one or more view components. Did you forget to hook up the IBOutlets?")
        }
        
        contentView.frame = bounds
        addSubview(contentView)
        
        for label in labels {
            label.delegate = self
        }
    }
    
    private func labelValues(for display:String) -> [String] {
        
        var labelValues = labels.map({ label in " " })
        
        for i in 0 ..< labels.count {
            let textReversed = text.reversed()
            if (textReversed.count > (i)) {
                let index = textReversed.index(textReversed.startIndex, offsetBy: i)
                labelValues[i] = String(textReversed[index])
            }
        }
        
        return labelValues.reversed()
    }
    
    private func updateLabels(with values:[String]) {
        let zipped = zip(labels, values)
        _ = zipped.map { (label, value) -> Void in
            label.newCharacter = value
        }
    }
    
    private func updateLabels(newFontSize: CGFloat) {
        _ = labels.map({$0.font = UIFont(name: $0.font.fontName, size: newFontSize)})
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var maskViewFrame:CGRect = labelMaskView.frame
        
        self.backgroundColor = UIColor.clear
        
        for (i,label) in labels.enumerated() {
            label.fitToFrame()
            label.center.y = self.contentView.center.y
            let labelWidth = label.font.pointSize * 0.6
            
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
            maskViewFrame.size.height = label.font.lineHeight * 0.7
        }
        
        labelMaskView.frame = maskViewFrame
        labelMaskView.center.y = contentView.center.y
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear, UIColor.white, UIColor.white, UIColor.clear].map { $0.cgColor }
        gradientLayer.locations = [0.0, 0.1, 0.9, 1.0]
        gradientLayer.frame = labelMaskView.bounds
        
        labelMaskView.backgroundColor = UIColor.clear
        labelMaskView.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.mask = labelMaskView.layer
    }
    
    //MARK: - Value Management Methods
    
    func checkTextNeedsUpdate() {
        let labelsReady:Bool = labels.reduce(true, { r, lB in r && !lB.scrolling })
        
        if (labelsReady && currentValue != value) {
            let incrementDirection = (value - currentValue) > 0 ? 1 : -1
            currentValue += incrementDirection
            
            targetScrollSpeed = Double(abs(value - currentValue))
            let incrementSpeed = (targetScrollSpeed - currentScrollSpeed) > 0 ? 1.0 : -1.0
            currentScrollSpeed += incrementSpeed
            currentScrollSpeed = currentScrollSpeed < 1 ? 1: currentScrollSpeed
        } else if (labelsReady){
            currentScrollSpeed = 1
            
            value =  Int(arc4random_uniform(20)) - 10
        }
    }
    
    //MARK: - Scrolling Character Label Delegate Methods
    
    func animationDirectionUpdated(direction: Int, for label: ScrollingCharacterLabel) {
        
        if (direction == 0 || label.rootCenter == nil) { return }
        
        let rootCenterY:CGFloat = (label.rootCenter?.y)!
        label.center.y = rootCenterY
        label.scrolling = true
        
        UIView.animate(withDuration: TimeInterval(1/currentScrollSpeed), delay: 0, options: .curveLinear, animations: {
            label.center.y = rootCenterY - label.font.lineHeight * CGFloat(direction)
        }) { (completed) in
            label.scrollingComplete()
            label.center.y = rootCenterY
            
            self.checkTextNeedsUpdate()
        }
    }
}
