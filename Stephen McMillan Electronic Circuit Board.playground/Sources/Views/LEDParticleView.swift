/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import SpriteKit

public class DamagedLEDEffectView: SKView {

    public var particleScene: SKScene
    public var particleEmitterNode: SKEmitterNode?
    
    lazy var sparkEmitter: SKEmitterNode? = DamagedLEDEffectView.getSparkEmitterNode()
    lazy var smokeEmitter: SKEmitterNode? = DamagedLEDEffectView.getSmokeEmitterNode()
    
    public override init(frame: CGRect) {
        
        particleScene = SKScene(size: frame.size)
        particleScene.backgroundColor = UIColor.clear
        super.init(frame: frame)
    
        backgroundColor = UIColor.clear
        self.presentScene(particleScene)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func particleExplodedAnimation() {
        
        if let sparkEmitterNode = sparkEmitter {
            
            particleEmitterNode = sparkEmitterNode
            particleEmitterNode?.position = CGPoint(x: 0 + self.frame.width/2, y: 0 + self.frame.height/2)
            self.particleScene.addChild(particleEmitterNode!)
            
            particleEmitterNode?.run(SKAction.wait(forDuration: 0.4), completion: {
                
                self.particleEmitterNode?.removeFromParent()
                
                if let smokeParticleEmitterNode = self.smokeEmitter {
                    
                    self.particleEmitterNode = smokeParticleEmitterNode
                    self.particleEmitterNode?.position = CGPoint(x: 0 + self.frame.width/2, y: 0 + self.frame.height/2)
                    self.particleScene.addChild(self.particleEmitterNode!)
                }
            })
        }
    }
    
    // Load textures
    static func getSparkEmitterNode() -> SKEmitterNode? {
        guard let particle = SKEmitterNode(fileNamed:   "LEDSparkParticleEffect") else {
            return nil
        }
        
        return particle
    }
    
    static func getSmokeEmitterNode() -> SKEmitterNode? {
        guard let particle = SKEmitterNode(fileNamed:   "LEDSmokeParticleEffect") else {
            return nil
        }
        
        return particle
    }
}
