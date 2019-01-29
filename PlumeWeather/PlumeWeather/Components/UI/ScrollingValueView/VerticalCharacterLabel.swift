//
//  ScrollingCharacter.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit


protocol ScrollingLabelHandler: class {
    var labels:[VerticalCharacterLabel] { get set }
}

final class VerticalCharacterLabel: UILabel, Scrollable {
    
    weak var animator:ScrollableAnimator?
    
    var scrollCenter:CGPoint?
    
    private var currentCharacter = " "
    var newCharacter = " " {
        didSet {
            scrollDirection = evaluateDirection()
            text = verticalString()
        }
    }
    
    var scrolling:Bool = false {
        didSet {
            if (!scrolling) {
                currentCharacter = newCharacter
                text = verticalString()
            }
        }
    }
    
    var scrollDirection:VerticalScrollDirection = .none {
        didSet {
            if (animator != nil) {
                animator?.scrollDirectionUpdated(direction: scrollDirection, cycleLength: font.lineHeight, for: self)
            }
        }
    }
    
    override func layoutSubviews() {
        if (scrollCenter == nil) {
            scrollCenter = center
        }
    }
    
    private func evaluateDirection() -> VerticalScrollDirection {
        if (currentCharacter == newCharacter) {
            return .none
        }
        
        guard let currentInt:Int = Int(currentCharacter) else { return .down}
        guard let newInt:Int = Int(newCharacter) else { return .up }
        
        if ((currentInt < newInt || currentInt-newInt > 8) && newInt-currentInt <= 8) {
            return .down
        }
        
        return .up
    }
    
    private func verticalString() -> String {
        var charArray:[String] = [" \n",currentCharacter + "\n"," \n"]
        charArray[1 + scrollDirection.value()] = newCharacter + "\n"
        return charArray.joined()
    }
    
    //MARK: - Helper Methods
    
    static func frameToFitFont(label:VerticalCharacterLabel, characterHeight:Int = 3) -> CGRect {
        var verticalFrame:CGRect = label.frame
        
        verticalFrame.size.width = label.font.pointSize * 0.6
        verticalFrame.size.height = label.font.lineHeight * CGFloat(characterHeight)
        
        return verticalFrame
    }
}
