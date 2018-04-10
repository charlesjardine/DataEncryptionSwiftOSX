//
//  SettingsViewController.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa
import ServiceManagement

class SettingsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func btnQuit(_ sender: Any) {
        
        let appBundleIdentifier = "nathan.dataencryption.com"
        SMLoginItemSetEnabled(appBundleIdentifier as CFString, true)
        //Test Code
        
        //let autoLaunch = (autoLaunchCheckbox.state == NSOnState)
        if SMLoginItemSetEnabled(appBundleIdentifier as CFString, true) {
//            if true {
//                NSLog("Successfully add login item.")
//            } else {
//                NSLog("Successfully remove login item.")
//            }
            
        } else {
            NSLog("Failed to add login item.")
        }
        
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.closeApp(self)
    }
}
