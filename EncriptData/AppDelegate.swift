//
//  AppDelegate.swift
//  EncriptData
//
//  Created by Charles Jardine on 04/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//  Update GIT

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

