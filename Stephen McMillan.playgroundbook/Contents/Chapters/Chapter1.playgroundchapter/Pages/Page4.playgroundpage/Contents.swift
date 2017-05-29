//#-hidden-code
/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - 1st Playground Page
 */
import PlaygroundSupport

enum LedColour: String {
    case red = "red"
    case orange = "orange"
    case blue = "blue"
}

func setLEDColour(_ colour: LedColour) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        
        proxy.send(.string(colour.rawValue))
    }
}

//#-end-hidden-code
/*:
 To conclude, I'll show you how to change the colour of the Light Emitting Diode.
 
 Different LED colours consume different amounts of voltage. This is known as voltage drop and it is modelled in my simulation. By altering the colour of the LED in the code below you should be able to see how the *current changes* when using a different colour LED.
 
 **Goal:** Change the colour of the LED to orange or blue.
 */

/* The voltage drop for each colour is detailed below.
 - Red (LedColour.red) : 1.8V drop
 - Orange (LedColour.orange) : 2.1V drop
 - Blue (LedColour.blue) : 3.6V drop
*/
setLEDColour(/*#-editable-code number of repetitions*/<#LedColour.red#>/*#-end-editable-code*/)

/*:
 *Feel free to experiment with the value adjustment panel as you've before with different LED colours and move on whever you're ready. ☺️*
*/
