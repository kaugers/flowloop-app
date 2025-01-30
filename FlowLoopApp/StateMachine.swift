//
//  StateMachine.swift
//  FlowLoop
//
//  Created by Viesturs Kaugers  on 21/09/2020.
//  Copyright © 2020 Viesturs Kaugers . All rights reserved.
//

import Foundation
import SwiftUI

class StateMachine: ObservableObject {
    static let shared = StateMachine()
    
    private var currentState: FlowState = .work
    private var beforePauseState: FlowState = .idle
    
    private var currentFlow: Int = 0;
    private var currentLoop: Int = 0;
    
    private var lastResetDay: Int = 0;
        
    init() {
        reset()
        resetLoopAfterMidnight()
    }
    
    func stateDescription(horizontal: Bool) -> String {
        switch currentState {
        case .idle:
            return horizontal ? "Idle" : "I"
        case .work:
            return horizontal ? "Work" : "W"
        case .shortBreak:
            return horizontal ? "Short break" : "SB"
        case .longBreak:
            return horizontal ? "Long break" : "LB"
        case .pause:
            return horizontal ? "Pause" : "P"
        }
    }
    
    func description(horizontal: Bool) -> String {
        let flows = String(currentState == .idle ? 0 : Configuration.shared.getFlowCount() - currentFlow)
        let loops = String(currentLoop)
                
        if (horizontal) {
            return "Flows to complete " + flows + " / Loops completed " + loops + " / " + stateDescription(horizontal: horizontal)
        } else {            
            return "F" + flows + "\n /\nL" + loops + "\n /\n" + stateDescription(horizontal: horizontal)
        }
    }
    
    func start() {
        Utils.playFlowSequenceInitiatedSound()
        currentState = .work
    }
    
    func pause() {
        Utils.playFlowSequencePausedSound()
        beforePauseState = currentState
        currentState = .pause
        print("paused")
    }
    
    func resume() {
        Utils.playFlowSequenceResumedSound()
        currentState = beforePauseState
        print("resumed")
    }
    
    func started() -> Bool {
        return currentState != .idle
    }

    func next() {
        if (current() == .work) {
            Utils.playWorkFlowCompletedSound()
            self.increaseFlow()
            currentState = currentFlow == Configuration.shared.getFlowCount() ? .longBreak : .shortBreak
            
            if (currentFlow == Configuration.shared.getFlowCount()) {
                self.increaseLoop()
            }
        } else if (current() == .shortBreak) {
            Utils.playShortFlowBreakCompletedSound()
            currentState = .work
        } else if (current() == .longBreak) {
            Utils.playLongFlowBreakCompletedSound()
            reset()
        }
        
        print("enter state", currentState)
    }
    
    func color() -> Color {
        if (current() == .longBreak) {
            return Configuration.shared.getLongBreakColor()
        } else if (current() == .work) {
            return Configuration.shared.getWorkColor()
        } else if (current() == .shortBreak) {
            return Configuration.shared.getShortBreakColor()
        }
        
        return Configuration.shared.getProgressBarColor()
    }
    
    func current() -> FlowState {
        return currentState
    }
    
    private func workTaskChange() -> Float {
        return 1 / Float(Configuration.shared.getWorkTask()) / 60
    }
    
    private func shortBreakChange() -> Float {
        return 1 / Float(Configuration.shared.getShortBreak()) / 60
    }
    
    private func longBreakChange() -> Float {
        return 1 / Float(Configuration.shared.getLongBreak()) / 60
    }
    
    private func change() -> Float {
        if (current() == .work) {
            return workTaskChange()
        } else if (current() == .shortBreak) {
            return shortBreakChange()
        } else if (current() == .longBreak) {
            return longBreakChange()
        }
        
        return 1
    }
    
    func progressValue() -> Float {
        return current() == .work || current() == .idle  ? 1 : 0
    }
    
    private func direction() -> Float {
        return current() == .work ? 1 : -1
    }
    
    func getValue() -> Float {
        let value = self.change() * self.direction()
        return value >= 0 || value <= 1 ? value : 0
    }
    
    func reset() {
        print("reset state")
        currentState = .idle
        currentFlow = 0;
    }
    
    func increaseFlow() {
        currentFlow += 1
        Statistics.shared.incFlow()
    }
    
    func increaseLoop() {
        currentLoop += 1
        Statistics.shared.incLoop()
    }
}

extension StateMachine {
    enum FlowState {
        case idle
        case work
        case shortBreak
        case longBreak
        case pause
    }
    
    func resetLoopAfterMidnight() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            let current = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            let hour = dateFormatter.string(from: current)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: current)
            
            if let day = components.day {
                if (hour == "00" && day > self.lastResetDay) {
                    self.currentLoop = 0
                    self.lastResetDay = day
                    print("reset loop after midnight")
                }
            }
        }
    }
}
