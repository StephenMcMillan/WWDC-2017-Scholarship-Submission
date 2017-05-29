///*
// Stephen McMillan
// WWDC 2017 'Circuit Board Simulation' Application
// March 2017 - Crafted with Care in Northern Ireland 🇬🇧
// */ NO TIME TO FINISH IMPLEMENTATION :(
//
//import UIKit
//
///// Creates a Simple Circuit board with a battery, switch, resistor and LED.
//public struct BuzzerCircuitBoard: HasBattery, HasToggleSwitch, HasBuzzer {
//    
//    // THIS CIRCUIT MODELS THE ORDER OF COMPONENTS AS:
//    // 1) Battery(+) --- Switch --- Buzzer --- Battery(-)
//    
//    // Components
//    public var battery: Battery {
//        didSet {
//            if battery.voltage > 0 {
//                buzzer.state = .activated
//            }
//        }
//    }
//    public var buzzer: Buzzer
//
//    public var toggleSwitch: ToggleSwitch {
//        didSet {
//            if toggleSwitch.toggled {
//                buzzer.state = .activated
//            }
//        }
//    }
//    
//    public var components: [ElectronicComponent]
//
//    
//    public init(battery: Battery) {
//        self.battery = battery
//        self.toggleSwitch = ToggleSwitch(toggled: false)
//        self.buzzer = Buzzer()
//        
//        components = [battery, toggleSwitch]
//    }
//}
//
//
