//
//  UpdateExtViewController.swift
//  Data Encription
//
//  Created by Charles Jardine on 05/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class UpdateExtViewController: NSViewController  {

    var expectedExt: NSMutableDictionary!
    @IBOutlet var plistAC: NSArrayController!
    @IBOutlet var tablView: NSTableView!
    @IBAction func btnClose(_ sender: NSButton) {
        //exit(0)
       
        let newKey = getString(title: "Enter a new file extention", question: "Extenstion Name", defaultValue: "")
        
        if(!newKey.isEmpty)
        {
            let d = PlistData(key: newKey, value: newKey + " File Type")
            let pData = Plist()
            pData.SaveToPlist(plist: "Mime", key: d.key as NSString, value: d.value as NSString)
            plistAC.addObject(d)
            self.tablView.reloadData()
        }
        
    }
    
    func GetMimeTypes()
    {
        let pData = Plist()
        expectedExt = pData.GetPlistData(plist: "Mime") as! NSMutableDictionary
    }
    
    override func viewWillDisappear() {
        //Todo remove plist items and fill with items in the table
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Allowed File Types"
        GetMimeTypes()
        
        for (key,value) in expectedExt {
            let d = PlistData(key: key as! String, value: value as! String)
            plistAC.addObject(d)
       }
        
    }
    
    func getString(title: String, question: String, defaultValue: String) -> String {
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = title
        msg.informativeText = question
        
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = defaultValue
        
        let txt1 = NSTextField(frame: NSRect(x: 0, y: 20, width: 200, height: 24))
        txt1.stringValue = defaultValue
        
        msg.accessoryView = txt
        let response: NSApplication.ModalResponse = msg.runModal()
        
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            return txt.stringValue
        } else {
            return ""
        }
    }
}
