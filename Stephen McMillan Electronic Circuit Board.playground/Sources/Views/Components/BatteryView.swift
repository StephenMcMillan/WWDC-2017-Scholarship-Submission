/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

public class BatteryView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override public func draw(_ rect: CGRect) {
        
        let thinLineWidth: CGFloat = rect.width / 20
        let thickLineWidth: CGFloat = (rect.width / 20) * 2
        
        // Top Cell +
        let topBatteryCellPositive = UIBezierPath()
        topBatteryCellPositive.move(to: CGPoint(x: 0, y: thinLineWidth/2))
        topBatteryCellPositive.addLine(to: CGPoint(x: rect.width, y: thinLineWidth/2))
        UIColor.black.setStroke()
        topBatteryCellPositive.lineWidth = thinLineWidth
        topBatteryCellPositive.stroke()
        
        // Top Cell -
        let topBatteryCellNegative = UIBezierPath()
        topBatteryCellNegative.move(to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.2 + thickLineWidth/2))
        topBatteryCellNegative.addLine(to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.2 + thickLineWidth/2))
        topBatteryCellNegative.lineWidth = thickLineWidth
        topBatteryCellNegative.stroke()

        
        // Bottom Cell +
        let bottomBatteryCellPositive = UIBezierPath()
        bottomBatteryCellPositive.move(to: CGPoint(x: rect.width * 0.3, y: rect.height - thickLineWidth/2))
        bottomBatteryCellPositive.addLine(to: CGPoint(x: rect.width * 0.7, y: rect.height - thickLineWidth/2))
        bottomBatteryCellPositive.lineWidth = thickLineWidth
        bottomBatteryCellPositive.stroke()
        
        // Bottom Cell -
        let bottomBatteryCellNegative = UIBezierPath()
        bottomBatteryCellNegative.move(to: CGPoint(x: 0, y: rect.height * 0.8 - thinLineWidth/2))
        bottomBatteryCellNegative.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.8 - thinLineWidth/2))
        bottomBatteryCellNegative.lineWidth = thinLineWidth
        bottomBatteryCellNegative.stroke()

        // Dashed Line
        let dashedConnector = UIBezierPath()
        dashedConnector.move(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        dashedConnector.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.8))
        dashedConnector.lineWidth = thinLineWidth
        UIGraphicsGetCurrentContext()?.setLineDash(phase: 1, lengths: [4,3])
        dashedConnector.stroke()
    }
}

