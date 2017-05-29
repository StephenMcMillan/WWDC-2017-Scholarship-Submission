/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

public class ToggleSwitchView: UIView {
    
    let rotationAngle = -10 * CGFloat.pi/180
    
    var middleOfSwitch: CAShapeLayer!
    
    public var toggled: Bool = false {
        willSet {
            animateSwitchMovement()
        }
    }
    
    override public init(frame: CGRect) {        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        
        let lineWidth: CGFloat = 4.0
        
        let ovalSize = CGSize(width: (rect.height - lineWidth)/2, height: (rect.height - lineWidth)/2)
        
        // First Circle
        let positiveCircle = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 0 + lineWidth/2, y: ovalSize.height + lineWidth/2), size: ovalSize))
        UIColor.black.setStroke()
        positiveCircle.lineWidth = lineWidth
        positiveCircle.stroke()
        
        // Second Circle
        let negativeCircle = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: rect.width - ovalSize.width - lineWidth/2, y: ovalSize.height + lineWidth/2), size: ovalSize))
        UIColor.black.setStroke()
        negativeCircle.lineWidth = lineWidth
        negativeCircle.stroke()
        
        // Close Line
        let closedLine = UIBezierPath(rect: CGRect(origin: CGPoint(x: positiveCircle.bounds.maxX, y: positiveCircle.bounds.midY - lineWidth/2), size: CGSize(width: negativeCircle.bounds.minX - positiveCircle.bounds.maxX, height: lineWidth)))
        
        // Line Between
        middleOfSwitch = CAShapeLayer()
        middleOfSwitch.path = closedLine.cgPath
        middleOfSwitch.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(middleOfSwitch)
        middleOfSwitch.position = CGPoint(x: middleOfSwitch.position.x - 2, y: middleOfSwitch.position.y)
        
        middleOfSwitch.transform = CATransform3DMakeRotation(rotationAngle, 0, 0, 1.0)
    }
    
    /// Animates the movement of the center component of the switch depending on what the current value of toggled is.
    func animateSwitchMovement() {
        
        let switchAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        switchAnimation.duration = 0.4
        switchAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if toggled {
            // Should animate the state from being toggled to being untoggled.
            middleOfSwitch.transform = CATransform3DMakeRotation(rotationAngle, 0, 0, 1.0)
            
            switchAnimation.fromValue = 0
            switchAnimation.toValue = rotationAngle
            
        } else {
            middleOfSwitch.transform = CATransform3DMakeRotation(0, 0, 0, 1.0)
            
            switchAnimation.toValue = 0
            switchAnimation.fromValue = rotationAngle
        
        }
        
        middleOfSwitch.add(switchAnimation, forKey: nil)
        
    }
}


