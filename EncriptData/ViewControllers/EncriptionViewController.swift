//
//  EncriptionViewController.swift
//  Data Encription
//
//  Created by Charles Jardine on 08/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class EncriptionViewController: NSViewController {

    class func loadFromNib() -> EncriptionViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EncriptionViewController")) as! EncriptionViewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func BtnClose(_ sender: NSButtonCell) {
       let appDelegate = NSApplication.shared.delegate as! AppDelegate
       appDelegate.closePopOver(self)
    }
}
