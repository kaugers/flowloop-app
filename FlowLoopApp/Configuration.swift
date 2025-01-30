//
//  Configuration.swift
//  FlowLoop
//
//  Created by Viesturs Kaugers  on 16/09/2020.
//  Copyright © 2020 Viesturs Kaugers . All rights reserved.
//

import Foundation
import SwiftUI
import Cocoa

class Configuration: ObservableObject {
    static let shared = Configuration()
    
    static let opacityWindows = 0.6
    static let opacityProgress = 0.85
    
    private static let progressBarColor = Color(hex: 0x8C8887, alpha: 1)
    private static let progressBarColorOpacity = Color(hex: 0x8C8887, alpha: opacityProgress)
    
    private static let workColor = Color(hex: 0x6b6968, alpha: 1)
    private static let workColorOpacity = Color(hex: 0x6b6968, alpha: opacityProgress)
    private static let pausedColor = Color(hex: 0x918F8E)
    private static let shortBreakColor = Color(hex: 0x68FF33)
    private static let shortBreakColorOpacity = Color(hex: 0x68FF33, alpha: opacityProgress)
    private static let longBreakColor = Color(hex: 0x3386FF)
    private static let longBreakColorOpacity = Color(hex: 0x3386FF, alpha: opacityProgress)
    
    public static let borderColor = Color(hex: 0x000000, alpha: 0.8)
    
    static let transparentBarDefault: Int = 0
    static let soundEffectsDefault: Int = 1
    static let displayStatusDefault: Int = 1
    static let shapeAlignmentDefault: Int = 1
    static let shapeSizeDefault: Int = 3
    static let startupDefault: Int = 0
    
    static let workTaskDefault: Int = 25
    static let shortBreakDefault: Int = 5
    static let longBreakDefault: Int = 30
    static let flowCountDefault: Int = 4
    
    static let progressBarThickness: CGFloat = 20

    private var transparentBar: Int = transparentBarDefault
    private var soundEffects: Int = soundEffectsDefault
    private var displayStatus: Int = displayStatusDefault
    private var shapeSize: Int = shapeSizeDefault
    private var startup: Int = startupDefault
    
    private var workTask: Int = workTaskDefault // 1
    private var shortBreak: Int = shortBreakDefault // 2
    private var longBreak: Int = longBreakDefault // 3
    
    private var flowCount: Int = flowCountDefault
    private var shapeAlignment: Int = shapeAlignmentDefault
    
    private var lastActice: Date = Date()
        

    private init() {
        self.initDefaults()
        self.load()
    }
    
    func getProgressBarColor() -> Color {
        return self.transparentBar == 1 ? Configuration.progressBarColorOpacity : Configuration.progressBarColor;
    }
    
    func getPausedColor() -> Color {
        return Configuration.pausedColor
    }
    
    func getOpacity() -> Double {
        return self.transparentBar == 1 ? Configuration.opacityWindows : 1
    }
    
    func getWorkColor() -> Color {
        return self.transparentBar == 1 ? Configuration.workColorOpacity : Configuration.workColor;
    }
    
    func getShortBreakColor() -> Color {
        return self.transparentBar == 1 ? Configuration.shortBreakColorOpacity : Configuration.shortBreakColor;
    }
    
    func getLongBreakColor() -> Color {
        return self.transparentBar == 1 ? Configuration.longBreakColorOpacity : Configuration.longBreakColor;
    }
    
    func initDefaults() {
        if UserDefaults.standard.object(forKey: "transparentBar") == nil {
            setTransparentBar(value: Configuration.transparentBarDefault)
        }
        
        if UserDefaults.standard.object(forKey: "soundEffects") == nil {
            setSoundEffects(value: Configuration.soundEffectsDefault)
        }
        
        if UserDefaults.standard.object(forKey: "displayStatus") == nil {
            setDisplayStatus(value: Configuration.displayStatusDefault)
        }
        
        if UserDefaults.standard.object(forKey: "shapeSize") == nil {
            setShapeSize(value: Configuration.shapeSizeDefault)
        }
        
        if UserDefaults.standard.object(forKey: "startup") == nil {
            setStartup(value: Configuration.startupDefault)
        }
        
        if UserDefaults.standard.object(forKey: "workTask") == nil {
            setWorkTask(value: Configuration.workTaskDefault)
        }
        
        if UserDefaults.standard.object(forKey: "shortBreak") == nil {
            setShortBreak(value: Configuration.shortBreakDefault)
        }
        
        if UserDefaults.standard.object(forKey: "longBreak") == nil {
            setLongBreak(value: Configuration.longBreakDefault)
        }
        
        if UserDefaults.standard.object(forKey: "flowCount") == nil {
            setFlowCount(value: Configuration.flowCountDefault)
        }
        
        if UserDefaults.standard.object(forKey: "shapeAlignment") == nil {
            setShapeAlignment(value: Configuration.shapeAlignmentDefault)
        }
    }
    
    func load() {
        transparentBar = UserDefaults.standard.integer(forKey: "transparentBar")
        soundEffects = UserDefaults.standard.integer(forKey: "soundEffects")
        displayStatus = UserDefaults.standard.integer(forKey: "displayStatus")
        shapeSize = UserDefaults.standard.integer(forKey: "shapeSize")
        startup = UserDefaults.standard.integer(forKey: "startup")
        workTask = UserDefaults.standard.integer(forKey: "workTask")
        shortBreak = UserDefaults.standard.integer(forKey: "shortBreak")
        longBreak = UserDefaults.standard.integer(forKey: "longBreak")
        flowCount = UserDefaults.standard.integer(forKey: "flowCount")
        shapeAlignment = UserDefaults.standard.integer(forKey: "shapeAlignment")
    }
    
    func setTransparentBar(value: Int) {
        UserDefaults.standard.set(value, forKey: "transparentBar")
        transparentBar = value
        objectWillChange.send()
    }
    
    func setSoundEffects(value: Int) {
        UserDefaults.standard.set(value, forKey: "soundEffects")
        soundEffects = value
        objectWillChange.send()
    }
    
    func setDisplayStatus(value: Int) {
        UserDefaults.standard.set(value, forKey: "displayStatus")
        displayStatus = value
        objectWillChange.send()
    }
    
    func setShapeSize(value: Int) {
        UserDefaults.standard.set(value, forKey: "shapeSize")
        shapeSize = value
        objectWillChange.send()
    }
    
    func setStartup(value: Int) {
        UserDefaults.standard.set(value, forKey: "startup")
        startup = value
        objectWillChange.send()
    }
    
    func setWorkTask(value: Int) {
        UserDefaults.standard.set(value, forKey: "workTask")
        workTask = value
        objectWillChange.send()
    }
    
    func setShortBreak(value: Int) {
        UserDefaults.standard.set(value, forKey: "shortBreak")
        shortBreak = value
        objectWillChange.send()
    }
    
    func setLongBreak(value: Int) {
        UserDefaults.standard.set(value, forKey: "longBreak")
        longBreak = value
        objectWillChange.send()
    }

    func setFlowCount(value: Int) {
        UserDefaults.standard.set(value, forKey: "flowCount")
        flowCount = value
        objectWillChange.send()
    }
    
    func setShapeAlignment(value: Int) {
        UserDefaults.standard.set(value, forKey: "shapeAlignment")
        shapeAlignment = value
        objectWillChange.send()
    }
    
    func getTransparentBar() -> Int {
        return transparentBar
    }
    
    func getSoundEffects() -> Int {
        return soundEffects
    }
    
    func getDisplayStatus() -> Int {
        return displayStatus
    }
    
    func getShapeSize() -> Int {
        return shapeSize
    }
    
    func getStartup() -> Int {
        return startup
    }
    
    func getWorkTask() -> Int {
       return workTask
    }
    
    func getShortBreak() -> Int {
        return shortBreak
    }
    
    func getLongBreak() -> Int {
        return longBreak
    }

    func getFlowCount() -> Int {
        return flowCount
    }
    
    func getShapeAlignment() -> Int {
        return shapeAlignment
    }
    
    func updateLastActive() {
        lastActice = Date()
    }
    
    func getLastActive() -> Date {
        return lastActice
    }
}

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
