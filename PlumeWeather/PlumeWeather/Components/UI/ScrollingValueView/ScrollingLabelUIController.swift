//
//  ScrollingLabelViewController.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit

class ScrollingValueUIController: ScrollableAnimatorDelegate {
    
    var labels: [VerticalCharacterLabel] = []
    
    var value:Int = 0 {
        didSet {
            incrementValue()
        }
    }
    
    private var currentValue:Int = 0 {
        didSet {
            text = String(currentValue)
        }
    }
    
    private var text:String = "  0" {
        didSet {
            updateLabels(with: labelValuesArray(for: text))
        }
    }
    
    private var currentAnimatorSpeed:Double = 1
    private var targetAnimatorSpeed:Double = 1
    
    init(labels: [VerticalCharacterLabel]) {
        self.labels = labels
    }
    
    private func labelValuesArray(for display:String) -> [String] {
        
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
    
    //MARK: - Value Management Methods
    
    func incrementValue() {
        let labelsReady:Bool = labels.reduce(true, { previousReady, currentLabel in previousReady && !currentLabel.scrolling })
        
        if (labelsReady && currentValue != value) {
            
            let incrementDirection = (value - currentValue) > 0 ? 1 : -1
            currentValue += incrementDirection
            
            updateAnimationSpeed()
            
        } else if (labelsReady){
            currentAnimatorSpeed = 1
        }
    }
    
    //MARK: - Animator Delegate Methods
    
    private func updateAnimationSpeed() {
        
        targetAnimatorSpeed = Double(abs(value - currentValue))
        let incrementSpeed = (targetAnimatorSpeed - currentAnimatorSpeed) > 0 ? 1.0 : -1.0
        currentAnimatorSpeed += incrementSpeed
        currentAnimatorSpeed = currentAnimatorSpeed < 1 ? 1: currentAnimatorSpeed
    }
    
    func animationCycleComplete(for scrollable: Scrollable, with animator:ScrollableAnimator) {
        incrementValue()
        animator.currentScrollSpeed = currentAnimatorSpeed
    }
}
