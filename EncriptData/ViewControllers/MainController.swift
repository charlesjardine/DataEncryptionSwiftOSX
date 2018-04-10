//
//  MainController.swift
//  Data Encription
//
//  Created by Charles Jardine on 09/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class MainController: NSTabViewController {

    class func loadFromNib() -> MainController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainController")) as! MainController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // tabView.layer?.backgroundColor = NSColor.blue.cgColor
       //var test = NSApplication.shared.t
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = NSSize(width: 450, height: 260)
        //self.view.layer?.backgroundColor = NSColor.blue.cgColor
    }
    
}
