import PlaygroundSupport
import UIKit

let playgroundPage = PlaygroundPage.current

let circuitModel = SimpleCircuitBoard(battery: Battery(voltage: 9), resistorValue: 330, ledColour: LED.LEDColours.red)
let circuit = SimpleCircuitBoardVisual(frame: CGRect(x: 0, y: 0, width: 400, height: 300), circuitModel: circuitModel)

// Allows the circuit to be centered and look nice in the live view.
let container = CircuitBoardContainerViewController(circuitView: circuit)

playgroundPage.liveView = container
