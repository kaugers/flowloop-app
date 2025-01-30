import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    @IBOutlet weak var transparentBar: NSButtonCell!
    @IBOutlet weak var soundEffects: NSButtonCell!
    @IBOutlet weak var displayStatus: NSButton!
    @IBOutlet weak var shapeAlignment: NSPopUpButton!
    @IBOutlet weak var shapeSize: NSSlider!
    @IBOutlet weak var workTask: NSTextField!
    @IBOutlet weak var shortBreak: NSTextField!
    @IBOutlet weak var longBreak: NSTextField!
    @IBOutlet weak var flowCount: NSTextField!
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
	let preferencePaneTitle = "General"
	let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!

	override var nibName: NSNib.Name? { "GeneralPreferenceViewController" }

	override func viewDidLoad() {
		super.viewDidLoad()
        self.load()
    }
    
    override func viewDidAppear() {
        self.load()
    }
    
    func load() {
        transparentBar.state = NSControl.StateValue(rawValue: Configuration.shared.getTransparentBar())
        soundEffects.state = NSControl.StateValue(rawValue: Configuration.shared.getSoundEffects())
        displayStatus.state = NSControl.StateValue(rawValue: Configuration.shared.getDisplayStatus())
        shapeSize.intValue = Int32(Configuration.shared.getShapeSize())
        workTask.intValue = Int32(Configuration.shared.getWorkTask())
        shortBreak.intValue = Int32(Configuration.shared.getShortBreak())
        longBreak.intValue = Int32(Configuration.shared.getLongBreak())
        flowCount.intValue = Int32(Configuration.shared.getFlowCount())
        shapeAlignment.selectItem(withTag: Configuration.shared.getShapeAlignment())
    }
    
    @IBAction func transparentBarChanged(_ sender: Any) {
        print(transparentBar.state)
        Configuration.shared.setTransparentBar(value: transparentBar.state.rawValue)
        
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.updateAlpha()
        }
    }
    
    @IBAction func soundEffectChanged(_ sender: Any) {
        print(soundEffects.state)
        Configuration.shared.setSoundEffects(value: soundEffects.state.rawValue)
    }
    
    @IBAction func displayStatusChanged(_ sender: Any) {
        print(displayStatus.state)
        Configuration.shared.setDisplayStatus(value: displayStatus.state.rawValue)
    }
    
    @IBAction func shapeSizeChanged(_ sender: Any) {
        print(shapeSize.intValue)
        Configuration.shared.setShapeSize(value: Int(shapeSize.intValue))

        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.centerInScreen(self)
        }
    }
    
    func saveSettings() {
        print("workTask", workTask.intValue)
        Configuration.shared.setWorkTask(value: Int(workTask.intValue))
        print("shortBreak", shortBreak.intValue)
        Configuration.shared.setShortBreak(value: Int(shortBreak.intValue))
        print("longBreak", longBreak.intValue)
        Configuration.shared.setLongBreak(value: Int(longBreak.intValue))
        print("flowCount", flowCount.intValue)
        Configuration.shared.setFlowCount(value: Int(flowCount.intValue))
        
        StateMachine.shared.reset()
    }
    
    func resetSettings() {
        workTask.intValue = Int32(Configuration.workTaskDefault)
        shortBreak.intValue = Int32(Configuration.shortBreakDefault)
        longBreak.intValue = Int32(Configuration.longBreakDefault)
        flowCount.intValue = Int32(Configuration.flowCountDefault)
        self.saveSettings()
    }
    
    @IBAction func applyPresssed(_ sender: Any) {
        if (StateMachine.shared.current() == .idle) {
            saveSettings()
            return
        }
        
        if (self.dialogOKCancel(question: "Reset to default settings?", text: "This will reset your current flow.")) {
            saveSettings()
        }
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        if (StateMachine.shared.current() == .idle) {
            resetSettings()
            return
        }
        
        if (self.dialogOKCancel(question: "Reset to default settings?", text: "This will reset your current flow.")) {
            resetSettings()
        }
    }
    
    @IBAction func shapeAlignmentChanged(_ sender: Any) {
        print(shapeAlignment.selectedItem!.tag)
        Configuration.shared.setShapeAlignment(value: Int(shapeAlignment.selectedItem!.tag))
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let res = alert.runModal()
        
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        
        return false
    }    
}
