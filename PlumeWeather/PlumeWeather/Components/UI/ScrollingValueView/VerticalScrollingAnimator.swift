//
//  ScrollingAnimator.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit

class VerticalScrollingAnimator: ScrollableAnimator {
    
    weak var delegate: ScrollableAnimatorDelegate?
    
    var currentScrollSpeed:Double = 1
    
    func scrollDirectionUpdated(direction: VerticalScrollDirection, cycleLength:CGFloat, for scrollable: Scrollable) {
        
        if (direction == .none || scrollable.scrollCenter == nil) {  scrollable.scrolling = false; return }
        
        let scrollCenterY:CGFloat = scrollable.scrollCenter!.y
        scrollable.center.y = scrollCenterY
        scrollable.scrolling = true
        
        UIView.animate(withDuration: TimeInterval(1/currentScrollSpeed), delay: 0, options: .curveLinear, animations: {
            scrollable.center.y = scrollCenterY - cycleLength * CGFloat(direction.value())
        }) { (completed) in
            
            scrollable.scrolling = false
            scrollable.center.y = scrollCenterY
            
            if (self.delegate != nil) {
                self.delegate?.animationCycleComplete(for: scrollable, with: self)
            }
        }
    }
}
