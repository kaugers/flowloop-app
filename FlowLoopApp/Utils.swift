//
//  Utils.swift
//  FlowLoop
//
//  Created by Viesturs Kaugers on 18/09/2020.
//  Copyright © 2020 Viesturs Kaugers . All rights reserved.
//

import SwiftUI
import Foundation
import AVFoundation

class Utils {
    static var audioPlayer: AVAudioPlayer!
    
    static func playSound(sound: String, type: String) {
        if (Configuration.shared.getSoundEffects() == 1) {
            let audioFilePath = Bundle.main.path(forResource: sound, ofType: type)
            
            do {
                let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!);
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: nil);
                audioPlayer.play()
            } catch {
                fatalError("Audio initialization error.")
            }
        }
    }
    
    static func playFlowSequenceInitiatedSound() {
        Utils.playSound(sound: "smb_powerup", type: "m4a")
    }
    
    static func playWorkFlowCompletedSound() {
        Utils.playSound(sound: "smb_coin", type: "m4a")
    }
    
    static func playShortFlowBreakCompletedSound() {
        Utils.playSound(sound: "smb_fireball", type: "m4a")
    }
    
    static func playLongFlowBreakCompletedSound() {
        Utils.playSound(sound: "smb_1-up", type: "m4a")
    }
    
    static func playFlowSequencePausedSound() {
        Utils.playSound(sound: "smb_pause", type: "m4a")
    }
    
    static func playFlowSequenceResumedSound() {
        Utils.playSound(sound: "smb_stomp", type: "m4a")
    }
    
    static func getProgressBarWidth() -> CGFloat {
        let screen = NSScreen.main
        let description = screen?.deviceDescription
        
        let displayPixelWidth = CGDisplayPixelsWide(description?[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID ?? 0)
        
        let goldenRatio = (1+sqrt(5))/2
        var multiplier = 1.0;
        
        if (Configuration.shared.getShapeSize() == 1) {
            multiplier = 3.0
        } else if (Configuration.shared.getShapeSize() == 2) {
            multiplier = 2.0
        } else if (Configuration.shared.getShapeSize() == 3) {
            multiplier = 1.0
        } else if (Configuration.shared.getShapeSize() == 4) {
            multiplier = 0.75
        } else if (Configuration.shared.getShapeSize() == 5) {
            multiplier = 0.65
        }
        print("multiplier: ", multiplier)
        
        if (Configuration.shared.getShapeAlignment() == 1) {
            print("s: horizontal")
            print("width: ", Int(Double(displayPixelWidth)/(multiplier*goldenRatio)))
            return CGFloat(Int(Double(displayPixelWidth)/(multiplier*goldenRatio)))
        }
        
        return Configuration.progressBarThickness
    }
    
    static func getProgressBarHeight() -> CGFloat {
        let screen = NSScreen.main
        let description = screen?.deviceDescription
        
        let displayPixelHeight = CGDisplayPixelsHigh(description?[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID ?? 0)
        
        let goldenRatio = (1+sqrt(5))/2
        var multiplier = 1.0;
        
        if (Configuration.shared.getShapeSize() == 1) {
            multiplier = 3.0
        } else if (Configuration.shared.getShapeSize() == 2) {
            multiplier = 2.0
        } else if (Configuration.shared.getShapeSize() == 3) {
            multiplier = 1.0
        } else if (Configuration.shared.getShapeSize() == 4) {
            multiplier = 0.75
        } else if (Configuration.shared.getShapeSize() == 5) {
            multiplier = 0.65
        }
        print("multiplier: ", multiplier)
        
        if (Configuration.shared.getShapeAlignment() == 0) {
            print("alignment: vertical")
            print("height: ", Int(Double(displayPixelHeight)/(multiplier*goldenRatio)))
            return CGFloat(Int(Double(displayPixelHeight)/(multiplier*goldenRatio)))
        }
        
        return Configuration.progressBarThickness
    }
}

// Extension for HEX color support
extension Color {
    init(hex: Int, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
