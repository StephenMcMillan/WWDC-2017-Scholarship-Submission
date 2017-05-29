/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit
import SpriteKit

class LEDDiodeSymbol: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Draw the triangle
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 0 + LEDView.lineWidth/2, y: LEDView.lineWidth/2))
        trianglePath.addLine(to: CGPoint(x: rect.width - LEDView.lineWidth/2, y: LEDView.lineWidth/2))
        
        trianglePath.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height - LEDView.lineWidth/2))
        
        trianglePath.close()
        
        trianglePath.move(to: CGPoint(x: 0, y: rect.height - LEDView.lineWidth/2))
        trianglePath.addLine(to: CGPoint(x: rect.width, y: rect.height - LEDView.lineWidth/2))
        
        trianglePath.lineWidth = LEDView.lineWidth
        UIColor.black.setStroke()
        trianglePath.stroke()
    }
}

class LEDArrows: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let triangleSideLength = rect.height - rect.height * 0.85
        
        // First arrow
        let midPointArrow1 = triangleSideLength + LEDView.lineWidth/2
        
        let firstArrow = UIBezierPath()
        firstArrow.move(to: CGPoint(x: rect.width - LEDView.lineWidth/2, y: midPointArrow1))
        firstArrow.addLine(to: CGPoint(x: rect.width - triangleSideLength, y: LEDView.lineWidth))
        firstArrow.addLine(to: CGPoint(x: rect.width - triangleSideLength, y: triangleSideLength * 2))
        firstArrow.close()
        firstArrow.fill()
        
        firstArrow.move(to: CGPoint(x: rect.width - triangleSideLength, y: midPointArrow1))
        firstArrow.addLine(to: CGPoint(x: triangleSideLength/2, y: midPointArrow1))
        
        firstArrow.lineWidth = LEDView.lineWidth
        UIColor.black.setStroke()
        firstArrow.stroke()
        
        // Second arrow
        let midPointArrow2 = rect.height - triangleSideLength - LEDView.lineWidth/2
        
        let secondArrow = UIBezierPath()
        secondArrow.move(to: CGPoint(x: rect.width - LEDView.lineWidth/2, y: midPointArrow2))
        secondArrow.addLine(to: CGPoint(x: rect.width - triangleSideLength, y: rect.height - LEDView.lineWidth))
        secondArrow.addLine(to: CGPoint(x: rect.width - triangleSideLength, y: rect.height - triangleSideLength * 2))
        secondArrow.close()
        secondArrow.fill()
        
        secondArrow.move(to: CGPoint(x: rect.width-triangleSideLength, y: midPointArrow2))
        secondArrow.addLine(to: CGPoint(x: triangleSideLength/2, y: midPointArrow2))
        
        secondArrow.lineWidth = LEDView.lineWidth
        secondArrow.stroke()
    }
}

public class LEDView: UIView {

    static let lineWidth: CGFloat = 4.0
    
    public var illuminated: Bool {
        didSet {
            updateParticleEffect()
        }
    }
    
    public var particleView: SKView!
    var particleScene: SKScene!
    var particleEffect: SKEmitterNode!
    
    var arrowView: LEDArrows!
    
    override public init(frame: CGRect) {
        
        illuminated = false
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Particle Light-Up Effect
    func configureParticleView() {
        particleView = SKView(frame: self.bounds)
        particleView.backgroundColor = UIColor.clear
        particleScene = SKScene(size: particleView.bounds.size)
        particleScene.backgroundColor = UIColor.clear
        particleView.presentScene(particleScene)
        
        self.insertSubview(particleView, aboveSubview: arrowView)
                
        guard let particle = SKEmitterNode(fileNamed: "LEDLightParticleEffect") else {
            return
        }
        
        particleEffect = particle
        particleEffect.position = CGPoint(x: particleScene.frame.width/2, y: particleScene.frame.height/2 + 5)
        particleScene.addChild(particleEffect)
        
        updateParticleEffect()
    }
    
    func updateParticleEffect() {
        if illuminated {
            // Light up
            particleEffect.run(SKAction.fadeIn(withDuration: 0.15))
        } else {
            // Turn off
            particleEffect.run(SKAction.fadeOut(withDuration: 0.15))
        }
    }
    
    public func changeParticleColour(colour: LEDColour) {
        particleEffect.particleColorSequence = SKKeyframeSequence(keyframeValues: [colour.colour], times: [0])
    }
    
    // Drawing
    public override func draw(_ rect: CGRect) {
        
        let diodeViewWidth = self.bounds.width * 0.55
        let diodeViewHeight = self.bounds.width * 0.55
        
        let diodeView = LEDDiodeSymbol(frame: CGRect(origin: CGPoint(x: self.bounds.width/2 - diodeViewWidth/2, y: self.bounds.height/2 - diodeViewHeight/2), size: CGSize(width: diodeViewWidth, height: diodeViewHeight)))
        self.addSubview(diodeView)
        
        let arrowViewWidth = diodeView.bounds.width * 0.5
        
        arrowView = LEDArrows(frame: CGRect(x: diodeView.frame.maxX - arrowViewWidth/3, y: diodeView.frame.maxY - arrowViewWidth * 1.4, width: arrowViewWidth, height: arrowViewWidth))
        arrowView.transform = CGAffineTransform(rotationAngle: 45 * CGFloat.pi/180)
        
        self.addSubview(arrowView)
        
        // Positive and Negative
        let rectCenter = rect.width/2
        
        let wire = UIBezierPath()
        wire.move(to: CGPoint(x: rectCenter, y: 0))
        wire.addLine(to: CGPoint(x: rectCenter, y: diodeView.frame.minY))
        
        wire.move(to: CGPoint(x: rectCenter, y: diodeView.frame.maxY))
        wire.addLine(to: CGPoint(x: rectCenter, y: rect.height))
        
        wire.lineWidth = LEDView.lineWidth
        UIColor.black.setStroke()
        wire.stroke()
        
        configureParticleView()
    }
}
