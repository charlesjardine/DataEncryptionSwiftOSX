//
//  AppDelegate.swift
//  EncriptData
//  Created by Charles Jardine on 04/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//  Update public GIT Repo at https://github.com/charlesjardine/DataEncryptionSwiftOSX.git

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    //let menu = NSMenu()
    public let popover = NSPopover()
   // var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let pData = Plist()
        let mimeData = MimeTypes().mimeTypes
        let mData = pData.GetPlistData(plist: "Mime")
        
        if(mData.count == 0)
        {
            for (key, value) in mimeData {
                //print("\(key) -> \(value)")
                pData.SaveToPlist(plist: "Mime",key: key as NSString, value: value as NSString)
            }
        }
        
        //Setup Menu Items
        
        if let button = statusBarItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "MenuBar"))
            button.action = #selector(toggleWindowMain(_:forEvent:))
        }
       
        popover.contentViewController = MainController.loadFromNib()
        
        popover.contentViewController?.view.wantsLayer = true
        popover.contentViewController?.view.layer?.backgroundColor = NSColor.black.cgColor
        
        popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight) //NSAppearance.current
        
//        eventMonitor = EventMonitor(mask: [.leftMouseUp,.rightMouseUp], handler: {(event) -> () in
//            if self.popover.isShown {
//                self.closePopOver(event)
//            }
//        })
    }

    func showPopOver(_ sender: Any?)
    {
        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
       // eventMonitor?.start()
    }
    
    func closePopOver(_ sender: Any?)
    {
        popover.performClose(sender)
       // eventMonitor?.stop()
    }
    
    func closeApp(_ sender: Any?)
    {
        popover.performClose(sender)
    
        exit(0)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

//    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//        return true
//    }
    
    @objc func toggleWindowMain(_ sender: Any, forEvent event: NSStatusBarButton)
    {
        if popover.isShown {
            closePopOver(sender)
        }
        else
        {
           showPopOver(sender)
        }
    }
    

}

