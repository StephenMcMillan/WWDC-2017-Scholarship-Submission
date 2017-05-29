/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

public class BuzzerView: UIView, HasConnectionPoints {
    
    var positiveConnectionPoint: CGPoint {
        return CGPoint(x: self.frame.minX + lineWidth/2, y: self.frame.minY)
    }
    var negativeConnectionPoint: CGPoint {
        return CGPoint(x: self.frame.minX + lineWidth/2, y: self.frame.maxX)
    }
    
    var lineWidth: CGFloat = 4.0

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        
        UIColor.black.setStroke()
        
        // Draw the positive wire from the top of the half circle to the top of the view.
        let positiveWire = UIBezierPath()
        positiveWire.move(to: CGPoint(x: lineWidth/2, y: 0))
        positiveWire.addLine(to: CGPoint(x: lineWidth/2, y: rect.height * 0.3))
        positiveWire.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.3))
        positiveWire.lineWidth = lineWidth
        positiveWire.stroke()
        
        // Draw the negative wire from the bottom of the half circle on the top of the view.
        let negativeWire = UIBezierPath()
        negativeWire.move(to: CGPoint(x: lineWidth/2, y: rect.height))
        negativeWire.addLine(to: CGPoint(x: lineWidth/2, y: rect.height * 0.7))
        negativeWire.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.7))
        negativeWire.lineWidth = lineWidth
        negativeWire.stroke()
        
        // Draw the half circle section of the buzzer with the enclosing end.
        let arc = UIBezierPath(arcCenter: CGPoint(x: rect.width - lineWidth/2, y: rect.height * 0.5), radius: rect.width * 0.5 - lineWidth/2, startAngle: CGFloat.pi/2, endAngle: (CGFloat.pi * 3)/2, clockwise: true)
        arc.lineWidth = lineWidth
        UIColor.white.setFill()
        arc.fill()
        arc.close()
        arc.stroke()
    }
    
}



