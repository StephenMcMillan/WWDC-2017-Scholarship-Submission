/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit

public typealias Volts = Double
public typealias Ohms = Double
public typealias Amps = Double
public typealias LEDColour = (colour: UIColor, forwardVoltage: Volts)

/// ----------------- Electronic Components -------------------- ///
public protocol ElectronicComponent {}

public struct Battery: ElectronicComponent {
    var voltage: Volts
    
    public init(voltage: Volts) {
        self.voltage = voltage
    }
}

public struct Resistor: ElectronicComponent {
    var value: Ohms
    
    public init(value: Ohms) {
        self.value = value
    }

}

public struct LED: ElectronicComponent {
    
    // These currents are milli-amps
    static let maxCurrent: Amps = 26.0
    static let minCurrent: Amps = 2.0
    
    public var forwardVoltage: Volts
    
    public struct LEDColours {
        public static let red = (colour: UIColor.red, forwardVoltage: Volts(1.8))
        public static let orange = (colour: UIColor.orange, forwardVoltage: Volts(2.1))
        public static let blue = (colour: UIColor.blue, forwardVoltage: Volts(3.6))
    }
    
    public enum LEDState {
        case off
        case on
        case destroyed
        case lowCurrent
    }
    
    public var colour: LEDColour {
        didSet {
            self.forwardVoltage = colour.forwardVoltage
        }
    }
    public var state: LEDState
    
    static func state(forCurrent current: Amps) -> LEDState {
        // Current is * by 100 as value referenced from LED datasheet was in mA (Milliamps)
        let minCurrentDecreasedOpacity = minCurrent * 2
        
        if (minCurrentDecreasedOpacity..<maxCurrent).contains(current * 1000) {
            // Current is within LEDs operating limit.
            return LEDState.on
        } else if (minCurrent..<minCurrentDecreasedOpacity).contains(current * 1000) {
            return LEDState.lowCurrent
        } else if current * 1000 >= maxCurrent {
            return LEDState.destroyed
        } else {
            return LEDState.off
        }
    }
    
    public init(colour: LEDColour) {
        self.colour = colour
        self.state = .off
        // The colour of an LED can have an affect on the amount of voltage that LED consumes. This is simulated.
        self.forwardVoltage = colour.forwardVoltage
    }
}

public struct Buzzer: ElectronicComponent {
    public enum BuzzerState {
        case activated
        case off
    }
    
    public var state: BuzzerState = .off
}

public struct ToggleSwitch: ElectronicComponent {
    public var toggled: Bool
    
    public init(toggled: Bool = false) {
        self.toggled = toggled
    }
}


/// ----------------- Components Protocols -------------------- ///

/* Battery */
public protocol HasBattery {
    var battery: Battery { get set }
}

/* Resistor */
public protocol HasResistor {
    var resistor: Resistor { get set }
}

/* LED */
public protocol HasLED {
    var led: LED { get set }
}

/* Buzzer */
public protocol HasBuzzer {
    var buzzer: Buzzer { get set }
}

/* Toggle Switch */
public protocol HasToggleSwitch {
    var toggleSwitch: ToggleSwitch { get set }
    
    mutating func operateToggleSwitch()
}

public extension HasToggleSwitch{
    mutating func operateToggleSwitch() {
        self.toggleSwitch.toggled = !toggleSwitch.toggled
    }
}
