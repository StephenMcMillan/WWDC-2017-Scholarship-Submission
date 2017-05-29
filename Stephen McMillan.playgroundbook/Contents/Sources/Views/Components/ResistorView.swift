/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

public class ResistorView: UIView {
    
    let lineWidth: CGFloat = 4.0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
    
        let resistorPath = UIBezierPath()
        resistorPath.move(to: CGPoint(x: 0 + lineWidth/2, y: 0 + lineWidth/2))
        resistorPath.addLine(to: CGPoint(x: rect.width - lineWidth/2, y: 0 + lineWidth/2))
        
        resistorPath.addLine(to: CGPoint(x: rect.width - lineWidth/2, y: rect.height - lineWidth/2))
        resistorPath.addLine(to: CGPoint(x: 0 + lineWidth/2, y: rect.height - lineWidth/2))
        resistorPath.close()
        
        UIColor.black.setStroke()
        resistorPath.lineWidth = lineWidth
        resistorPath.stroke()
    
    }
}
