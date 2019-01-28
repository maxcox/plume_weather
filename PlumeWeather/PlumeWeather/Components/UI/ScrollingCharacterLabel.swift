//
//  ScrollingCharacter.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollingCharacterDelegate: class {
    func animationDirectionUpdated(direction:Int, for label: ScrollingCharacterLabel)
}

final class ScrollingCharacterLabel: UILabel {
    
    weak var delegate:ScrollingCharacterDelegate?
    
    var rootCenter:CGPoint?
    
    var scrolling:Bool = false
    
    private var currentCharacter = " "
    
    var newCharacter = " " {
        didSet {
            animationDirection = evaluateDirection()
            updateVerticalString()
        }
    }
    
    private var animationDirection:Int = 0 {
        didSet {
            if (delegate != nil) {
                delegate?.animationDirectionUpdated(direction: animationDirection, for: self)
            }
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
    }
    
    override func layoutSubviews() {
        if (rootCenter == nil) {
            rootCenter = center
        }
    }
    
    private func evaluateDirection() -> Int {
        if (currentCharacter == newCharacter) {
            return 0
        }
        
        guard let currentInt:Int = Int(currentCharacter) else { return -1}
        guard let newInt:Int = Int(newCharacter) else { return 1 }
        
        if ((currentInt < newInt || currentInt-newInt > 8) && newInt-currentInt <= 8) {
            return -1
        }
        
        return 1
    }
    
    private func updateVerticalString() {
        var charArray:[String] = [" \n",currentCharacter + "\n"," \n"]
        charArray[1 + animationDirection] = newCharacter + "\n"
        text = charArray.joined()
    }
    
    func fitToFrame() {
        var verticalFrame:CGRect = self.frame
        
        verticalFrame.size.width = self.font.pointSize * 0.6
        verticalFrame.size.height = self.font.lineHeight * 3
        
        self.frame = verticalFrame
    }
    
    func scrollingComplete() {
        currentCharacter = newCharacter
        updateVerticalString()
        scrolling = false
    }
    
    func getAnimationDirection() -> Int {
        return animationDirection
    }
}
