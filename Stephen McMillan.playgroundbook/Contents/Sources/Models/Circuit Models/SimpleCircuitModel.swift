/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

/// Creates a Simple Circuit board with a battery, switch, resistor and LED.
public struct SimpleCircuitBoard: HasBattery, HasToggleSwitch, HasResistor, HasLED {
    
    // THIS CIRCUIT MODELS THE ORDER OF COMPONENTS AS:
    // 1) Battery(+) --- Switch --- LED --- Resistor --- Battery(-)
    
    // Components
    public var battery: Battery {
        didSet {
            led.state = LED.state(forCurrent: current)
            print("BATT VOLT WAS SET TO \(battery.voltage)")
        }
    }
    public var led: LED
    
    public var resistor: Resistor {
        didSet {
            led.state = LED.state(forCurrent: current)
            print("RESISTANCE WAS SET TO \(resistor.value)")
        }
    }
    
    public var toggleSwitch: ToggleSwitch {
        didSet {
            led.state = LED.state(forCurrent: current)
            print(led.state)
        }
    }
    
    public var components: [ElectronicComponent]
    
    // Led uses voltage so current is determined by subtracting the forward voltage of an LED from the Batterys voltage
    public var current: Amps {
        return (toggleSwitch.toggled ? (battery.voltage - led.forwardVoltage) : 0) / resistor.value
    }
    
    public init(battery: Battery, resistorValue: Ohms, ledColour: LEDColour) {
        self.battery = battery
        self.resistor = Resistor(value: resistorValue)
        self.led = LED(colour: ledColour)
        self.toggleSwitch = ToggleSwitch(toggled: false)
        
        components = [battery, resistor, led, toggleSwitch]
    }
}


