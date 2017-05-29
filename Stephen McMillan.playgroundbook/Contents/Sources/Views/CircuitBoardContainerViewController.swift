/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

// View that will make sure that the circuit is always center on the live view and fixed size, regarldess of the orientation or size of the live view.

public class CircuitBoardContainerViewController: UIViewController {
    
    public var circuitView: SimpleCircuitBoardVisual
    public var valueSelectorView: CircuitBoardValueSelectionView

    public init(circuitView: SimpleCircuitBoardVisual) {
        self.circuitView = circuitView
        
        self.valueSelectorView = CircuitBoardValueSelectionView(
            frame: CGRect(x: 0, y: 0, width: circuitView.frame.width, height: circuitView.frame.height),
            lastValues: (lastVoltage: circuitView.circuitModel.battery.voltage, lastResistance: circuitView.circuitModel.resistor.value)
        )
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
        
        // Selector view should be initially hidden.
        valueSelectorView.isHidden = true
        
        self.view.addSubview(circuitView)
        self.view.addSubview(valueSelectorView)
        setupLayoutConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(transitionBetweenCircuitViewAndSelectorView))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayoutConstraints() {
        
        circuitView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsToConstrain: [UIView] = [circuitView, valueSelectorView]
        let widthOfViews = self.circuitView.frame.size.width
        let heightOfViews = self.circuitView.frame.size.height
        
        viewsToConstrain.forEach {
            $0.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: widthOfViews).isActive = true
            $0.heightAnchor.constraint(equalToConstant: heightOfViews).isActive = true
        }

        view.layoutIfNeeded()
    }
    
    func transitionBetweenCircuitViewAndSelectorView() {
                
        let transitionDuration = 0.8
        var transitionOptions: UIViewAnimationOptions
        
        if !circuitView.isHidden && valueSelectorView.isHidden {
            // Transitioning from the circuit view to the selector view.
            transitionOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
            
            valueSelectorView.resistorValueSlider.value = Float(circuitView.circuitModel.resistor.value)
            valueSelectorView.batteryVoltageSlider.value = Float(circuitView.circuitModel.battery.voltage)
            valueSelectorView.resistorSliderValueChanged()
            valueSelectorView.batterySliderValueChanged()
            
        } else {
            // Transitiong back from the selector view to the circuit view.
            // Maybe reset the circuit model with the updated values in here.
            transitionOptions = [.transitionFlipFromTop, .showHideTransitionViews]
            
            if circuitView.circuitModel.toggleSwitch.toggled != false {
                circuitView.circuitModel.operateToggleSwitch()
            }
            
            circuitView.circuitModel.battery.voltage = Volts(round(valueSelectorView.batteryVoltageSlider.value*10)/10)
            circuitView.circuitModel.resistor.value = Ohms(round(valueSelectorView.resistorValueSlider.value*10)/10)
            
        }
        
        UIView.transition(with: circuitView, duration: transitionDuration, options: transitionOptions, animations: { 
            self.circuitView.isHidden = !self.circuitView.isHidden
        }, completion: nil)
        
        UIView.transition(with: valueSelectorView, duration: transitionDuration, options: transitionOptions, animations: { 
            self.valueSelectorView.isHidden = !self.valueSelectorView.isHidden
        }, completion: nil)
    }
}

