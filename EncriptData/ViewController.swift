//
//  ViewController.swift
//  EncriptData
//
//  Created by Charles Jardine on 04/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let ScreenStart = NSSize(width: (NSScreen.main?.frame.width)! / 4, height: (NSScreen.main?.frame.height)! / 4)
        
        self.view.frame.size = ScreenStart
        self.view.frame.origin = NSPoint(x: (NSScreen.main?.frame.origin.x)!/2, y: (NSScreen.main?.frame.height)! / 2)
        
    }

    override func viewDidAppear() {
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

