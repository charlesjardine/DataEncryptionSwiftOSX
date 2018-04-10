//
//  ShowHideViewController.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class ShowHideViewController: NSViewController {

    let popover = NSPopover()
    override func viewDidLoad() {
        super.viewDidLoad()
        popover.contentViewController = HiddenFilesLookupViewController.loadFromNib()
    }
    
    @IBOutlet var btnShow: NSButton!
    @IBAction func btnShowlist(_ sender: Any) {
       
        if popover.isShown {
            closePopOver(sender)
        }
        else
        {
            showPopOver(sender)
        }
    }
    
    func showPopOver(_ sender: Any?)
    {
         popover.show(relativeTo: btnShow.bounds, of: btnShow, preferredEdge: NSRectEdge.minY)
    }
    
    func closePopOver(_ sender: Any?)
    {
        popover.performClose(sender)
    }
}
