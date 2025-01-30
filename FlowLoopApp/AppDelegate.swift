//
//  AppDelegate.swift
//  FlowLoopApp
//
//  Created by Viesturs Kaugers  on 20/08/2020.
//  Copyright © 2020 Viesturs Kaugers . All rights reserved.
//

// defaults delete com.kaugers.flowloop

import Cocoa
import SwiftUI
import Preferences

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    var startupWindow: NSWindow!
    var contentView: ContentView!
    var statisticsWindow: NSWindow!
    var statisticsView: StatisticsView!
    var introView = IntroView()
    
    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            GeneralPreferenceViewController()
        ]
    )
    
    @IBAction
    func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        self.contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 200),
            styleMask: [.borderless],
            backing: .buffered, defer: false)
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: self.contentView)
        window.makeKeyAndOrderFront(nil)
        
        setupWindow();
        self.startupView();
    }

    func setupWindow() {
        window.level = .mainMenu
        window.hidesOnDeactivate = false
        window.hasShadow = true
        window.center()
        window.isMovableByWindowBackground = true
        window.isExcludedFromWindowsMenu = false
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
        ]
        window.titleVisibility = .hidden
        
        window.titlebarAppearsTransparent = true
        window.isOpaque = false
        window.backgroundColor = .clear
        
        updateAlpha()
    }
    
    func startupView(ignoreOnce: Bool = false) {
        if (!ignoreOnce && Configuration.shared.getStartup() == 1) {
            return
        }
        
        Configuration.shared.setStartup(value: 1)
        
        startupWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        startupWindow.contentView = NSHostingView(rootView: self.introView)
        startupWindow.makeKeyAndOrderFront(nil)
        startupWindow.level = .mainMenu
        startupWindow.hasShadow = true
        startupWindow.title = "Introduction"
        startupWindow.isMovableByWindowBackground = true
        startupWindow.isExcludedFromWindowsMenu = true
        startupWindow.titleVisibility = .visible
        startupWindow.titlebarAppearsTransparent = false
        startupWindow.isOpaque = false
        startupWindow.backgroundColor = .clear
        startupWindow.isReleasedWhenClosed = false
        startupWindow.center()
        startupWindow.delegate = self
        
        self.introView.start();
    }
    
    func showStatisticsView() {
        statisticsView = StatisticsView()
        
        statisticsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        statisticsWindow.contentView = NSHostingView(rootView: statisticsView)
        statisticsWindow.makeKeyAndOrderFront(nil)
        statisticsWindow.level = .mainMenu
        statisticsWindow.hasShadow = true
        statisticsWindow.title = "Statistics"
        statisticsWindow.isMovableByWindowBackground = true
        statisticsWindow.isExcludedFromWindowsMenu = true
        statisticsWindow.titleVisibility = .visible
        statisticsWindow.titlebarAppearsTransparent = false
        statisticsWindow.isOpaque = false
        statisticsWindow.isReleasedWhenClosed = false
        statisticsWindow.center()
    }
    
    func windowWillClose(_: Notification) {
        self.introView.stop()
    }    
    
    func updateAlpha() {
        window.animator().alphaValue = CGFloat(Configuration.shared.getOpacity())
        print("alpha: ", window.animator().alphaValue)
    }
        
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        // Restore last windows position - not working.
        // self.window.setFrameAutosaveName("FlowLoop")
        Configuration.shared.updateLastActive()
        print(self.window.frame)
    }
    
    @IBAction func centerInScreen(_ sender: Any) {
        self.window.center();
    }
    
    @IBAction func resetFlow(_ sender: Any) {
        StateMachine.shared.reset();
        self.contentView.resetProgressBar()
    }
    
    @IBAction func showHelp(_ sender: Any) {
        if let url = URL(string: "https://flowloop.io"), NSWorkspace.shared.open(url) {
        }
    }
    
    @IBAction func showIntro(_ sender: Any) {
        self.startupView(ignoreOnce: true)
    }
    
    @IBAction func showStatistics(_ sender: Any) {
        self.showStatisticsView()
    }
}

extension Preferences.PaneIdentifier {
    static let general = Self("general")
}
