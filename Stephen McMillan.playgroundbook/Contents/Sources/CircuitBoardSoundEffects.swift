/*
 Stephen McMillan
 WWDC 2017 'Circuit Board Simulation' Application
 March 2017 - Crafted with Care in Northern Ireland 🇬🇧
 */

import UIKit
import AVFoundation

protocol CanPlayCircuitSounds: class {
    var toggleSwitchClick: AVAudioPlayer! { get set }
}

extension CanPlayCircuitSounds {
    func setupSounds() {
        
        if let path = Bundle.main.path(forResource: "toggleSwitchClicked", ofType: ".caf") {
            do {
                self.toggleSwitchClick = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            } catch {
                return
            }
            toggleSwitchClick.prepareToPlay()
        }
    }
}

