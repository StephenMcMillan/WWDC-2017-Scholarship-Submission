/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit
import SpriteKit
import AVFoundation

public class SimpleCircuitBoardVisual: UIView, CanPlayCircuitSounds {
    
    static let lineWidthForDrawing: CGFloat = 4.0
    
    public var circuitModel: SimpleCircuitBoard {
        didSet {
            // Something changed about the model so the visual represenation should be updated.
            modelDidChange()
        }
    }
    
    // Audio
    var toggleSwitchClick: AVAudioPlayer!
    
    // Component Views
    var batteryView: BatteryView
    var ledView: LEDView
    var resistorView: ResistorView
    var toggleSwitchView: ToggleSwitchView
    
    var batteryFrame: CGRect
    var ledFrame: CGRect
    var toggleSwitchFrame: CGRect
    var resistorFrame: CGRect
    
    var circuitInfoStatusLabel: UILabel!
    
    var componentFriedVisible: Bool = false
    
    public init(frame: CGRect, circuitModel: SimpleCircuitBoard) {
        self.circuitModel = circuitModel
        
        // Need to save frame so that the components can be scaled in nicely without offsetting the drawing the 'wires'/paths
        batteryFrame = CGRect(x: frame.height * 0.2 - 25, y: frame.height * 0.5 - 35, width: 50, height: 70)
        batteryView = BatteryView(frame: batteryFrame)
        batteryView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        toggleSwitchFrame = CGRect(x: frame.width * 0.5 - 50, y: frame.height * 0.25 - 20, width: 90, height: 35)
        toggleSwitchView = ToggleSwitchView(frame: toggleSwitchFrame)
        toggleSwitchView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        ledFrame = CGRect(x: frame.width * 0.8 - 40, y: frame.height * 0.5 - 37.5, width: 80, height: 75)
        ledView = LEDView(frame: ledFrame)
        ledView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        resistorFrame = CGRect(x: frame.width * 0.5 - 40 , y: frame.height * 0.75 - 15, width: 80, height: 30)
        resistorView = ResistorView(frame: resistorFrame)
        resistorView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // Desig init
        super.init(frame: frame)
        
        // Sets up the sounds for the circuit audio eg. toggle switch clicks
        setupSounds()
        
        // Add the component views
        self.addSubview(batteryView)
        self.addSubview(toggleSwitchView)
        self.addSubview(ledView)
        self.addSubview(resistorView)
        
        // Some Styling to make the view presentable...
        backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 4.0
        
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Setup the toggle switch to register touch.
        let toggleSwitchTapGestureRecgoniser = UITapGestureRecognizer(target: self, action: #selector(registeredTouchOnToggleSwitch))
        toggleSwitchView.addGestureRecognizer(toggleSwitchTapGestureRecgoniser)
        
        // Status label 
        setupStatusLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Circuit Logic Methods
    func registeredTouchOnToggleSwitch() {
        circuitModel.operateToggleSwitch()
        toggleSwitchClick.play()
    }
    
    func modelDidChange() {
        // What state should the toggle switch be in...
        
        if toggleSwitchView.toggled != circuitModel.toggleSwitch.toggled {
            toggleSwitchView.toggled = circuitModel.toggleSwitch.toggled
        }
        
        
        print("THE CURRENT ON THE CIRCUIT IS: \(circuitModel.current*1000) mA")
        
        updateLEDViewState()
        
        updateCircuitInfoStatusLabel()
        
    }
    
    func updateLEDViewState() {
        // What state should the LED be in...
        
        ledView.changeParticleColour(colour: circuitModel.led.colour)
        
        switch circuitModel.led.state {
        case .off:
            ledView.illuminated = false
        case .on:
            ledView.illuminated = true
            ledView.particleView.alpha = 1.0
        case .destroyed:
            
            guard componentFriedVisible != true else {
                return
            }
            
            ledView.illuminated = false
            componentFriedVisible = true
            
            let explosion = DamagedLEDEffectView(frame:  CGRect(x: ledView.frame.midX - 75, y: ledView.frame.midY - 100, width: 150, height: 200))
            self.insertSubview(explosion, aboveSubview: resistorView)
            
            explosion.particleExplodedAnimation()
            
        case .lowCurrent:
            ledView.illuminated = true
            ledView.particleView.alpha = 0.5
        }
    }
    
    // MARK: Status Label
    func setupStatusLabel() {
        circuitInfoStatusLabel = UILabel()
        circuitInfoStatusLabel.textColor = UIColor(colorLiteralRed: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
        
        circuitInfoStatusLabel.font = UIFont.systemFont(ofSize: 12.0)
        circuitInfoStatusLabel.text = "n.a"
        circuitInfoStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        circuitInfoStatusLabel.alpha = 0
        self.addSubview(circuitInfoStatusLabel)
        
        circuitInfoStatusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        circuitInfoStatusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
        updateCircuitInfoStatusLabel()
    }
    
    func updateCircuitInfoStatusLabel() {
        if componentFriedVisible == true {
            circuitInfoStatusLabel.text = "⚠️ LED exceeded maximum operating current."
            
            let resetButton = UIButton(type: .system)
            resetButton.setTitle("Reset", for: UIControlState.normal)
            resetButton.tintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
            resetButton.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(resetButton)
            
            resetButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            resetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
            resetButton.addTarget(self, action: #selector(resetCircuitState(_:)), for: UIControlEvents.touchUpInside)
            
            layoutIfNeeded()
            
        } else {
            let estCurrent = circuitModel.current * 1000
            circuitInfoStatusLabel.text = "🔋 \(round(circuitModel.battery.voltage*10)/10)V | Current: \(round(estCurrent*1000)/1000) mA"
        }
    }
    
    func resetCircuitState(_ sender: UIButton) {
        
        componentFriedVisible = false
        
        circuitModel = SimpleCircuitBoard(battery: Battery(voltage: 9.1), resistorValue: 330, ledColour: LED.LEDColours.red)
        sender.removeFromSuperview()
        
        self.subviews.forEach { (view) in
            if view is DamagedLEDEffectView {
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: Methods relating to drawing the circuit
    public override func draw(_ rect: CGRect) {
        drawView()
    }
    
    func drawView(animated: Bool = true) {
        
        // Fade in battery.
        UIView.animate(withDuration: 0.2) {
            self.batteryView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        // Draw line to toggle
        drawLineToToggleSwitch() // 0.8 second duration
        
        // Fade in toggle
        UIView.animate(withDuration: 0.2, delay: 0.8, options: [], animations: {
            self.toggleSwitchView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        // Draw line to led
        drawLineToLED() // 0.8 duration
        
        // fade in led
        UIView.animate(withDuration: 0.2, delay: 1.8, options: [], animations: {
            self.ledView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        // draw line to resistor
        drawLineToResistor()
        
        // fade in resistor
        UIView.animate(withDuration: 0.2, delay: 2.8, options: [], animations: {
            self.resistorView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        // line from resistor to battery
        drawLineToBatteryNegative()
        
        UIView.animate(withDuration: 0.4, delay: 3.6, options: [], animations: {
            self.circuitInfoStatusLabel.alpha = 1.0
        }, completion: nil)
    }
    
    // Code for Drawing lines and animating each of the components coming onto the view.
    internal func shapeLayerFromPath(path: CGPath, lineWidth: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }
    
    internal func animationForStroke() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.duration = 0.8
        return animation
    }
    
    func drawLineToToggleSwitch() {
        let heightOfToggleSwitchLine = toggleSwitchFrame.midY + toggleSwitchFrame.height/4.5
        let lineToToggle = UIBezierPath()
        lineToToggle.move(to: CGPoint(x: batteryFrame.midX, y: batteryFrame.minY))
        lineToToggle.addLine(to: CGPoint(x: batteryFrame.midX, y: heightOfToggleSwitchLine))
        lineToToggle.addLine(to: CGPoint(x: toggleSwitchFrame.minX, y: heightOfToggleSwitchLine))
        
        let toggleSwitchLine = shapeLayerFromPath(path: lineToToggle.cgPath, lineWidth: SimpleCircuitBoardVisual.lineWidthForDrawing)
        self.layer.addSublayer(toggleSwitchLine)
        
        let tsLAnimation = animationForStroke()
        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
        tsLAnimation.fillMode = kCAFillModeBackwards
        tsLAnimation.beginTime = CACurrentMediaTime() + 0.2
        toggleSwitchLine.add(tsLAnimation, forKey: nil)
    }
    
    func drawLineToLED() {
        let heightOfToggleSwitchLine = toggleSwitchFrame.midY + toggleSwitchFrame.height/4.5
        
        let lineToLed = UIBezierPath()
        lineToLed.move(to: CGPoint(x: toggleSwitchFrame.maxX, y: heightOfToggleSwitchLine))
        lineToLed.addLine(to: CGPoint(x: ledFrame.midX, y: heightOfToggleSwitchLine))
        lineToLed.addLine(to: CGPoint(x: ledFrame.midX, y: ledFrame.minY))
        
        let ledLineLayer = shapeLayerFromPath(path: lineToLed.cgPath, lineWidth: SimpleCircuitBoardVisual.lineWidthForDrawing)
        self.layer.addSublayer(ledLineLayer)
        
        let ledLineAnimation = animationForStroke()
        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
        ledLineAnimation.fillMode = kCAFillModeBackwards
        ledLineAnimation.beginTime = CACurrentMediaTime() + 1.2
        ledLineLayer.add(ledLineAnimation, forKey: nil)
    }
    
    func drawLineToResistor() {
        let lineToResistor = UIBezierPath()
        lineToResistor.move(to: CGPoint(x: ledFrame.midX, y: ledFrame.maxY))
        lineToResistor.addLine(to: CGPoint(x: ledFrame.midX, y: resistorFrame.midY))
        lineToResistor.addLine(to: CGPoint(x: resistorFrame.maxX, y: resistorFrame.midY))
        
        let resistorLineLayer = shapeLayerFromPath(path: lineToResistor.cgPath, lineWidth: SimpleCircuitBoardVisual.lineWidthForDrawing)
        self.layer.addSublayer(resistorLineLayer)
        
        let resistorLineAnimation = animationForStroke()
        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
        resistorLineAnimation.fillMode = kCAFillModeBackwards
        resistorLineAnimation.beginTime = CACurrentMediaTime() + 2.2
        resistorLineLayer.add(resistorLineAnimation, forKey: nil)
    }
    
    func drawLineToBatteryNegative() {
        let lineToBattery = UIBezierPath()
        lineToBattery.move(to: CGPoint(x: resistorFrame.minX, y: resistorFrame.midY))
        lineToBattery.addLine(to: CGPoint(x: batteryFrame.midX, y: resistorFrame.midY))
        lineToBattery.addLine(to: CGPoint(x: batteryFrame.midX, y: batteryFrame.maxY))
        
        let batteryLineLayer = shapeLayerFromPath(path: lineToBattery.cgPath, lineWidth: SimpleCircuitBoardVisual.lineWidthForDrawing)
        self.layer.addSublayer(batteryLineLayer)
        
        let batteryLineAnimation = animationForStroke()
        // Line from the battery to the switch happens after battery is faded in which is 0.2 seconds
        batteryLineAnimation.fillMode = kCAFillModeBackwards
        batteryLineAnimation.beginTime = CACurrentMediaTime() + 3.2
        batteryLineLayer.add(batteryLineAnimation, forKey: nil)
    }
}


