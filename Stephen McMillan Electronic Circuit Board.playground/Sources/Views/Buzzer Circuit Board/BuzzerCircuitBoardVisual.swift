///*
// Stephen McMillan
// WWDC 2017 'Circuit Board Simulation' Application
// March 2017 - Crafted with Care in Northern Ireland 🇬🇧
// */ TO BE FINISHED
//
//import UIKit
//import SpriteKit
//
//public class BuzzerCircuitBoardVisual: UIView {
//    
//    static let lineWidthForDrawing: CGFloat = 4.0
//    
//    var circuitModel: BuzzerCircuitBoard {
//        didSet {
//            modelDidChange()
//        }
//    }
//    
//    // Component Views
//    var batteryView: BatteryView
//    var buzzerView: BuzzerView
//    var toggleSwitchView: ToggleSwitchView
//    
//    var batteryFrame: CGRect
//    var buzzerFrame: CGRect
//    var toggleSwitchFrame: CGRect
//    
//    var componentFriedVisible: Bool = false
//    
//    public init(frame: CGRect, circuitModel: BuzzerCircuitBoard) {
//        self.circuitModel = circuitModel
//        
//        // Need to save frame so that the components can be scaled in nicely without offsetting the drawing the 'wires'/paths
//        batteryFrame = CGRect(x: frame.height * 0.2 - 25, y: frame.height * 0.5 - 35, width: 50, height: 70)
//        batteryView = BatteryView(frame: batteryFrame)
//        batteryView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        
//        toggleSwitchFrame = CGRect(x: frame.width * 0.5 - 50, y: frame.height * 0.25 - 20, width: 90, height: 35)
//        toggleSwitchView = ToggleSwitchView(frame: toggleSwitchFrame)
//        toggleSwitchView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        
//        buzzerFrame = CGRect(x: frame.width * 0.8 - 35, y: frame.height * 0.5 - 35, width: 70, height: 70)
//        buzzerView = BuzzerView(frame: buzzerFrame)
//        buzzerView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        
//        // Desig init
//        super.init(frame: frame)
//        
//        // Add the component views
//        self.addSubview(batteryView)
//        self.addSubview(toggleSwitchView)
//        self.addSubview(buzzerView)
//        
//        // Some Styling to make the view presentable...
//        backgroundColor = UIColor.clear
//        self.layer.backgroundColor = UIColor.white.cgColor
//        self.layer.cornerRadius = 4.0
//        
//        self.layer.shadowOpacity = 0.4
//        self.layer.shadowRadius = 3
//        self.layer.shadowOffset = CGSize(width: 1, height: 1)
//        
//        // Setup the toggle switch to register touch.
//        let toggleSwitchTapGestureRecgoniser = UITapGestureRecognizer(target: self, action: #selector(registeredTouchOnToggleSwitch))
//        toggleSwitchView.addGestureRecognizer(toggleSwitchTapGestureRecgoniser)
//    }
//    
//    public required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: Circuit Logic Methods
//    func registeredTouchOnToggleSwitch() {
//        circuitModel.operateToggleSwitch()
//    }
//    
//    func modelDidChange() {
//        // What state should the toggle switch be in...
//        
//        if toggleSwitchView.toggled != circuitModel.toggleSwitch.toggled {
//            toggleSwitchView.toggled = circuitModel.toggleSwitch.toggled
//        }
//        
//        updateBuzzerState()
//    }
//    
//    func updateBuzzerState() {        
//        // Play the sounds in here
//    }
//
//    // MARK: Methods relating to drawing the circuit
//    public override func draw(_ rect: CGRect) {
//        drawView()
//    }
//    
//    func drawView(animated: Bool = true) {
//        
//        // Fade in battery.
//        UIView.animate(withDuration: 0.2) {
//            self.batteryView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }
//        
//        // Draw line to toggle
//        drawLineToToggleSwitch()
//        
//        // Fade in toggle
//        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], animations: {
//            self.toggleSwitchView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }, completion: nil)
//        
//        // Draw line to buzzer
//        drawLineToBuzzerView()
//        
//        // fade in buzzer
//        UIView.animate(withDuration: 0.2, delay: 1.8, options: [], animations: {
//            self.buzzerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }, completion: nil)
//        
//        // draw line to battery negative
//        drawLineToBatteryNegative()
//    }
//    
//    // Code for Drawing lines and animating each of the components coming onto the view.
//    internal func shapeLayerFromPath(path: CGPath, lineWidth: CGFloat) -> CAShapeLayer {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path
//        shapeLayer.lineWidth = lineWidth
//        shapeLayer.strokeColor = UIColor.black.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        return shapeLayer
//    }
//    
//    internal func animationForStroke() -> CABasicAnimation {
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0
//        animation.toValue = 1.0
//        animation.duration = 0.8
//        return animation
//    }
//    
//    func drawLineToToggleSwitch() {
//        let heightOfToggleSwitchLine = toggleSwitchFrame.midY + toggleSwitchFrame.height/4.5
//        let lineToToggle = UIBezierPath()
//        lineToToggle.move(to: CGPoint(x: batteryFrame.midX, y: batteryFrame.minY))
//        lineToToggle.addLine(to: CGPoint(x: batteryFrame.midX, y: heightOfToggleSwitchLine))
//        lineToToggle.addLine(to: CGPoint(x: toggleSwitchFrame.minX, y: heightOfToggleSwitchLine))
//        
//        let toggleSwitchLine = shapeLayerFromPath(path: lineToToggle.cgPath, lineWidth: SimpleCircuitBoardVisual.lineWidthForDrawing)
//        self.layer.addSublayer(toggleSwitchLine)
//        
//        let tsLAnimation = animationForStroke()
//        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
//        tsLAnimation.fillMode = kCAFillModeBackwards
//        tsLAnimation.beginTime = CACurrentMediaTime() + 0.2
//        toggleSwitchLine.add(tsLAnimation, forKey: nil)
//    }
//    
//    func drawLineToBuzzerView() {
//        let heightOfToggleSwitchLine = toggleSwitchFrame.midY + toggleSwitchFrame.height/4.5
//        
//        let lineToBuzzer = UIBezierPath()
//        lineToBuzzer.move(to: CGPoint(x: toggleSwitchFrame.maxX, y: heightOfToggleSwitchLine))
//        lineToBuzzer.addLine(to: CGPoint(x: buzzerFrame.minX + BuzzerCircuitBoardVisual.lineWidthForDrawing/2, y: heightOfToggleSwitchLine))
//        lineToBuzzer.addLine(to: CGPoint(x: buzzerFrame.minX + BuzzerCircuitBoardVisual.lineWidthForDrawing/2, y: buzzerFrame.minY))
//        
//        let buzzerLineLayer = shapeLayerFromPath(path: lineToBuzzer.cgPath, lineWidth: BuzzerCircuitBoardVisual.lineWidthForDrawing)
//        self.layer.addSublayer(buzzerLineLayer)
//        
//        let buzzerLineAnimation = animationForStroke()
//        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
//        buzzerLineAnimation.fillMode = kCAFillModeBackwards
//        buzzerLineAnimation.beginTime = CACurrentMediaTime() + 1.2
//        buzzerLineLayer.add(buzzerLineAnimation, forKey: nil)
//    }
//    
//    func drawLineToBatteryNegative() {
//        let lineToBattery = UIBezierPath()
//        lineToBattery.move(to: CGPoint(x: buzzerFrame.minX + BuzzerCircuitBoardVisual.lineWidthForDrawing/2, y: buzzerFrame.maxY))
//        lineToBattery.addLine(to: CGPoint(x: buzzerFrame.minX + BuzzerCircuitBoardVisual.lineWidthForDrawing/2, y: self.bounds.height * 0.75))
//        lineToBattery.addLine(to: CGPoint(x: batteryFrame.midX, y: self.bounds.height * 0.75))
//        lineToBattery.addLine(to: CGPoint(x: batteryFrame.midX, y: batteryFrame.maxY))
//        
//        let batteryLineLayer = shapeLayerFromPath(path: lineToBattery.cgPath, lineWidth: SimpleCircuitBoardVisual.lineWidthForDrawing)
//        self.layer.addSublayer(batteryLineLayer)
//        
//        let batteryLineAnimation = animationForStroke()
//        batteryLineAnimation.duration = 1.6
//        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
//        batteryLineAnimation.fillMode = kCAFillModeBackwards
//        batteryLineAnimation.beginTime = CACurrentMediaTime() + 3.2
//        batteryLineLayer.add(batteryLineAnimation, forKey: nil)
//    }
//}
//
//
