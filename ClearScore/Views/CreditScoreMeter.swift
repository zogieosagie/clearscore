//
//  CreditScoreMeter.swift
//  ClearScore
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import UIKit

class CreditScoreMeter: UIView {
    
    var circleLayer: CAShapeLayer?

    init(frame: CGRect, requiredAngle :CGFloat, lineWidth :CGFloat, color :UIColor) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: (-1 * .pi/2), endAngle: requiredAngle, clockwise: true)

        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer?.path = circlePath.cgPath
        circleLayer?.fillColor = UIColor.clear.cgColor
        circleLayer?.strokeColor = color.cgColor
        circleLayer?.lineWidth = lineWidth;

        // Don't draw the circle initially
        circleLayer?.strokeEnd = 0.0

        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer!)
    }
    
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        // Set the animation duration appropriately
        animation.duration = duration

        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1

        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer?.strokeEnd = 1.0

        // Do the actual animation
        circleLayer?.add(animation, forKey: "animateCircle")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
