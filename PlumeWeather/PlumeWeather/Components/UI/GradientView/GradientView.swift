//
//  GradientView.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

//Simple two-color vertical gradient view
@IBDesignable class GradientView: UIView {
    
    @IBInspectable var colorA:UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var colorB:UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }
    
    let gradientLayer:CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame: CGRect, colorA:UIColor, colorB:UIColor) {
        super.init(frame: frame)
        
        self.colorA = colorA
        self.colorB = colorB
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        updateGradientLayer()
        
        backgroundColor = UIColor.clear
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateGradientLayer() {
        gradientLayer.colors = [colorA, colorB].map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
    }
    
    override func layoutSubviews() {
        //update CAGradientLayer frame to match changed bounds
        updateGradientLayer()
    }
}
