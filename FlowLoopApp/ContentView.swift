//
//  ContentView.swift
//  FlowLoopApp
//
//  Created by Viesturs Kaugers  on 20/08/2020.
//  Copyright © 2020 Viesturs Kaugers . All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var progressValue: Float = 1.0
    @State var color: Color = Configuration.shared.getProgressBarColor()
    @State var opacity: Double = Configuration.opacityProgress
    @ObservedObject var config = Configuration.shared
    @ObservedObject var state = StateMachine.shared
    
    var body: some View {
        VStack {
            ProgressBar(value: $progressValue, color: $color, opacity: $opacity).frame(width: Utils.getProgressBarWidth(), height: Utils.getProgressBarHeight())
                    .gesture(TapGesture(count: 2).onEnded {
                        // Skip double tap if windows was just activated, otherwise flow starts immediately
                        let lastActive = Configuration.shared.getLastActive().addingTimeInterval(0.5)
                        let current = Date()
                        
                        if (current > lastActive) {
                            if (self.state.current() != .pause && self.state.current() != .idle) {
                                self.pauseProgressBar()
                            } else {
                                self.startProgressBar()
                            }
                        }
                    })
        }
        .padding()
    }
    
    func changeProgress() {
        self.progressValue -= state.getValue()
        self.color = state.color()
//        print("self.progressValue ", self.progressValue)
    }
    
    func startProgressBar() {
        if (self.state.current() == .pause) {
            state.resume()
            return
        }
        
        self.state.start()
        self.progressValue = 1.0
        let seconds =  1.0 //0.07 - for debug
        
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
            if (self.state.current() != .pause) {
                self.changeProgress()
            }
            
            if (self.progressValue < 0 || self.progressValue > 1) {
                self.state.next()
                self.progressValue = self.state.progressValue()
            }
            
            if (self.state.current() == .idle) {
                timer.invalidate()
                self.resetProgressBar()
            }
        }
    }
    
    func resetProgressBar() {
        self.color = state.color()
        self.state.reset()
        self.progressValue = self.state.progressValue()
    }
    
    func pauseProgressBar() {
        self.state.pause()
        blink()
    }
}

extension ContentView {
    func blink() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if (self.state.current() != .pause) {
                timer.invalidate()
            }
            
            self.color = self.color == Configuration.shared.getWorkColor() ? Configuration.shared.getPausedColor() : Configuration.shared.getWorkColor()    
        }
    }
}
