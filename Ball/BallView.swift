//
//  BallView.swift
//  Ball
//
//  Created by Janet Weber on 4/28/16.
//  Copyright © 2016 Weber Solutions. All rights reserved.
//

import UIKit
import CoreMotion

class BallView: UIView {
    var acceleration = CMAcceleration(x: 0, y: 0, z: 0)
    private let image = UIImage(named : "ball")!
    
    private var currentPoint : CGPoint = CGPointZero {
        didSet {
            var newX = currentPoint.x
            var newY = currentPoint.y
            if newX < 0 {
                newX = 0
                ballXVelocity = 0
            } else if newX > bounds.size.width - image.size.width {
                newX = bounds.size.width - image.size.width
                ballXVelocity = 0
            }
            if newY < 0 {
                newY = 0
                ballYVelocity = 0
            } else if newY > bounds.size.height - image.size.height {
                newY = bounds.size.height - image.size.height
                ballYVelocity = 0
            }
            currentPoint = CGPointMake(newX, newY)
            
            let currentRect = CGRectMake(newX, newY,
                                         newX + image.size.width,
                                         newY + image.size.height)
            let prevRect = CGRectMake(oldValue.x, oldValue.y,
                                      oldValue.x + image.size.width,
                                      oldValue.y + image.size.height)
            setNeedsDisplayInRect(CGRectUnion(currentRect, prevRect))
        }
    }
    
    private var ballXVelocity = 0.0
    private var ballYVelocity = 0.0
    private var lastUpdateTime = NSDate()
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        image.drawAtPoint(currentPoint)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() -> Void {
        currentPoint = CGPointMake((bounds.size.width / 2.0) +
            (image.size.width / 2.0),
            (bounds.size.height / 2.0) +
            (image.size.height / 2.0))
    }

    func update() -> Void {
        let now = NSDate()
        let SecondsSinceLastDraw = now.timeIntervalSinceDate(lastUpdateTime)
        ballXVelocity = ballXVelocity + (acceleration.x * SecondsSinceLastDraw)
        ballYVelocity = ballYVelocity - (acceleration.y * SecondsSinceLastDraw)
        
        let xDelta = SecondsSinceLastDraw * ballXVelocity * 500
        let yDelta = SecondsSinceLastDraw * ballYVelocity * 500
        currentPoint = CGPointMake(currentPoint.x + CGFloat(xDelta),
                    currentPoint.y + CGFloat(yDelta))
        lastUpdateTime = now
    }
}
