//
//  EventMonitor.swift
//  Data Encription
//
//  Created by Charles Jardine on 08/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class EventMonitor {
    private var monitor: AnyObject?
    private var mask: NSEvent.EventTypeMask
    private var handler:  (NSEvent?) -> ()
    
    init(mask: NSEvent.EventTypeMask,handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }
    
    func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}

