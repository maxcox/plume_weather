//
//  Scrollable.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit

protocol Scrollable: class {
    
    var animator:ScrollableAnimator? { get set }
    
    var scrolling:Bool { get set }
    var scrollDirection:VerticalScrollDirection { get set }
    
    var center:CGPoint { get set }
    var scrollCenter:CGPoint? { get set }
}

protocol ScrollableAnimator: class {
    
    var delegate:ScrollableAnimatorDelegate? { get set }
    
    var currentScrollSpeed:Double { get set }
    
    func scrollDirectionUpdated(direction:VerticalScrollDirection, cycleLength:CGFloat, for label: Scrollable)
}

protocol ScrollableAnimatorDelegate: class {
    
    func animationCycleComplete(for scrollable:Scrollable, with animator: ScrollableAnimator)
}

enum VerticalScrollDirection {
    
    case none
    case up
    case down
    
    func value() -> Int {
        switch self {
        case .none:
            return 0
        case .up:
            return 1
        case .down:
            return -1
        }
    }
}

