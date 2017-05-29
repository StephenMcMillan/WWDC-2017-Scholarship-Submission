/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

public class CircuitBoardValueSelectionView: UIView {
    
    // Value Sliders
    var resistorValueSlider: UISlider!
    var batteryVoltageSlider: UISlider!
    
    // Labels
    var resistorSliderLabel: UILabel!
    var batteryVoltageSliderLabel: UILabel!
    
    var resistorSliderValueLabel: UILabel!
    var batteryVoltageValueLabel: UILabel!
    
    var estimatedCurrentLabel: UILabel!
    
    // rgba(189, 195, 199,1.0)
    let subLabelColour: UIColor = UIColor(colorLiteralRed: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
    
    // rgba(67, 144, 227, 1.0)
    let primaryLabelColour: UIColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)

    var estimatedCurrent: Amps {
        let current = (batteryVoltageSlider.value / resistorValueSlider.value)*1000
        return Amps(current)
    }
    
    public init(frame: CGRect, lastValues: (lastVoltage: Volts, lastResistance: Ohms)) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Some Styling to make the view presentable...
        backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 4.0
        
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        setupView(initialBatt: lastValues.lastVoltage, initialResistor: lastValues.lastResistance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure View Labels and Sliders 
    func setupView(initialBatt: Volts, initialResistor: Ohms) {
        let edgePadding: CGFloat = 15
        
        /// Battery Values * Top Section *
        setupBatterySelector(edgePadding)
        
        /// Estimated Current Label
        setupEstimatedCurrentLabel(edgePadding)
        
        /// Resistor Bottom Section
        setupResistorSelector(edgePadding)
        
        // Update view for new constraints
        layoutIfNeeded()
        
        // Make everything look good at the start.
        batteryVoltageSlider.minimumValue = 0
        batteryVoltageSlider.maximumValue = 60
        batteryVoltageSlider.value = Float(initialBatt)
        batteryVoltageValueLabel.text = "\(round(batteryVoltageSlider.value*10)/10)V"
        
        resistorValueSlider.minimumValue = 0
        resistorValueSlider.maximumValue = 10000
        resistorValueSlider.value = Float(initialResistor)
        resistorSliderValueLabel.text = "\(round(resistorValueSlider.value*10)/10)Ω"
        
        batteryVoltageSlider.addTarget(self, action: #selector(batterySliderValueChanged), for: UIControlEvents.valueChanged)
        resistorValueSlider.addTarget(self, action: #selector(resistorSliderValueChanged), for: UIControlEvents.valueChanged)
        
        print(estimatedCurrent)
        estimatedCurrentLabel.text = "Estimated Current: \(round(estimatedCurrent*1000)/1000) mA"
    }
    
    func setupBatterySelector(_ edgePadding: CGFloat) {
    
        // Battery Slider Label
        batteryVoltageSliderLabel = UILabel()
        batteryVoltageSliderLabel.textColor = subLabelColour
        batteryVoltageSliderLabel.text = "Set Battery Voltage"
        batteryVoltageSliderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(batteryVoltageSliderLabel)
        
        batteryVoltageSliderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgePadding).isActive = true
        batteryVoltageSliderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: edgePadding*2).isActive = true
        
        // Battery Slider
        batteryVoltageSlider = UISlider()
        batteryVoltageSlider.translatesAutoresizingMaskIntoConstraints = false
        batteryVoltageSlider.minimumTrackTintColor = primaryLabelColour
        self.addSubview(batteryVoltageSlider)
        
        batteryVoltageSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgePadding).isActive = true
        batteryVoltageSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgePadding).isActive = true
        batteryVoltageSlider.topAnchor.constraint(equalTo: batteryVoltageSliderLabel.bottomAnchor, constant: edgePadding).isActive = true
        
        // Battery Voltage Value 
        batteryVoltageValueLabel = UILabel()
        batteryVoltageValueLabel.textColor = primaryLabelColour
        batteryVoltageValueLabel.text = "9 V"
        batteryVoltageValueLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBold)
        batteryVoltageValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(batteryVoltageValueLabel)
        
        batteryVoltageValueLabel.bottomAnchor.constraint(equalTo: batteryVoltageSlider.topAnchor, constant: -edgePadding).isActive = true
        batteryVoltageValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgePadding).isActive = true
    }
    
    func setupResistorSelector(_ edgePadding: CGFloat) {
        // Resistor Slider
        resistorValueSlider = UISlider()
        resistorValueSlider.translatesAutoresizingMaskIntoConstraints = false
        resistorValueSlider.minimumTrackTintColor = primaryLabelColour
        self.addSubview(resistorValueSlider)
        
        resistorValueSlider.bottomAnchor.constraint(equalTo: self.estimatedCurrentLabel.topAnchor, constant: -edgePadding).isActive = true
        resistorValueSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgePadding).isActive = true
        resistorValueSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgePadding).isActive = true
        
        // Resistor Slider Label
        resistorSliderLabel = UILabel()
        resistorSliderLabel.textColor = subLabelColour
        resistorSliderLabel.text = "Set Resistor Value"
        resistorSliderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(resistorSliderLabel)
        
        resistorSliderLabel.bottomAnchor.constraint(equalTo: resistorValueSlider.topAnchor, constant: -edgePadding).isActive = true
        resistorSliderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgePadding).isActive = true
        
        // Resistor Slider Value Label
        resistorSliderValueLabel = UILabel()
        resistorSliderValueLabel.textColor = primaryLabelColour
        resistorSliderValueLabel.text = "330 Ω"
        resistorSliderValueLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBold)
        resistorSliderValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(resistorSliderValueLabel)
        
        resistorSliderValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgePadding).isActive = true
        resistorSliderValueLabel.bottomAnchor.constraint(equalTo: resistorValueSlider.topAnchor, constant: -edgePadding).isActive = true
    }
    
    func setupEstimatedCurrentLabel(_ edgePadding: CGFloat) {
        estimatedCurrentLabel = UILabel()
        estimatedCurrentLabel.textColor = subLabelColour
        estimatedCurrentLabel.font = UIFont.systemFont(ofSize: 12.0)
        estimatedCurrentLabel.text = "Estimated Current: n.a"
        estimatedCurrentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(estimatedCurrentLabel)
        
        estimatedCurrentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -edgePadding).isActive = true
        estimatedCurrentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    // Respond to changes in the sliders values
    func resistorSliderValueChanged() {
        resistorSliderValueLabel.text = "\(round(resistorValueSlider.value*10)/10)Ω"
        estimatedCurrentLabel.text = "Estimated Current: \(round(estimatedCurrent*1000)/1000) mA"
    }
    
    func batterySliderValueChanged() {
        batteryVoltageValueLabel.text = "\(round(batteryVoltageSlider.value*10)/10)V"
        estimatedCurrentLabel.text = "Estimated Current: \(round(estimatedCurrent*1000)/1000) mA"
    }
}
