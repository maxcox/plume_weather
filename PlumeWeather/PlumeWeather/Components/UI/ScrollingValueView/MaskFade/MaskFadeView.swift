//
//  MaskFadeView.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MaskFadeView: UIView {
    
    let gradientLayer:CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        gradientLayer.colors = [UIColor.clear, UIColor.white, UIColor.white, UIColor.clear].map { $0.cgColor }
        gradientLayer.locations = [0.0, 0.1, 0.9, 1.0]
        gradientLayer.frame = bounds
        
        backgroundColor = UIColor.clear
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        //update CAGradientLayer frame to match changed bounds
        gradientLayer.frame = bounds
    }
}
