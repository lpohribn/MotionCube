//
//  Shape.swift
//  MotionCube
//
//  Created by Liudmyla POHRIBNIAK on 3/24/19.
//  Copyright © 2019 Liudmyla POHRIBNIAK. All rights reserved.
//

import Foundation
import UIKit

class Shape: UIView {
    var size:CGFloat = 100
    var circle:Bool = false
    init(localpoint: CGPoint, maxwidth: CGFloat, maxheight: CGFloat)
    {
        var x = localpoint.x - (size / 2)
        var y = localpoint.y - (size / 2)
        
        if x + size  > maxwidth {
            x = maxwidth - size
        }
        if  x < 0 {
            x = 0
        }
        if y + size > maxheight {
            y -= size / 2
        }
        if y + size > maxheight {
            y = maxheight - size
        }
        
        let form = Int(arc4random_uniform(2))
        switch form {
        case 0:
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
            self.layer.cornerRadius = size / 2
            circle = true

        default:
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
        }
        self.backgroundColor = randomColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      func random() ->CGFloat {
            return CGFloat(arc4random()) / CGFloat(UInt32.max)
//            return CGFloat(arc4random() % 256) / 256

    }
    
    func randomColor() -> UIColor {
        return UIColor(red:   random(),
                       green: random(),
                       blue:  random(),
                       alpha: 0.8)
    }
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return (self.circle == true) ? .ellipse : .rectangle
    }
}
