//
//  EncryptViewController.swift
//  EncriptData
//
//  Created by Charles Jardine on 04/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Foundation
import Cocoa
import RNCryptor

class EncryptView: NSView {
    
    var filePath: String?
    var expectedExt = [""]
    var imageView = NSImageView()
    var labelText = "Drag Files Here to Encrypt"
    var cBackground = NSColor.black
    var cTextColour = NSColor.systemGreen
    var isMoving = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }
    
    func showLabel (labelText: String, point: CGPoint) -> NSTextField {
        let label = NSTextField(frame: NSMakeRect(point.x, point.y, self.bounds.width, 20))
        label.stringValue = labelText
        label.alignment = .center
        label.isEditable = false
        label.isBordered = false
        let border = CALayer()
        
        border.frame = CGRect(x: 0, y:0, width:  label.frame.size.width, height: label.frame.size.height)
        border.borderWidth = 2.0
        label.wantsLayer = true
        label.layer?.addSublayer(border)
        label.layer?.masksToBounds = true
        
        //Set Colours
        label.textColor = cTextColour
        label.backgroundColor = cBackground
        border.borderColor =  cTextColour.cgColor
        return label
    }
    
    func AddBackGroundView()
    {
        imageView = NSImageView(frame: CGRect(x:20,y:20,width:self.bounds.width - 40,height:self.bounds.height-40));
        imageView.removeFromSuperview()
        var image:NSImage!
        let name = NSImage.Name("dropfiles")
        image = NSImage(named:name)
        imageView.image = image;
        addSubview(imageView)
    }
    func RemoveBackGroundView()
    {
        imageView.removeFromSuperview()
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if(!isMoving)
        {
           AddBackGroundView()
        }
        AddLabel()
        needsLayout = true
    }

    override func viewDidEndLiveResize() {
        isMoving = false
        AddBackGroundView()
    }
    override func viewWillStartLiveResize()
    {
        isMoving = true
        imageView.removeFromSuperview()
    }
    func AddLabel()
    {
        let point = CGPoint(x:0,y:self.bounds.height - 20)
        let label = showLabel(labelText: labelText, point: point)
        label.removeFromSuperview()
        self.addSubview(label)
    }
    
    func GetMimeTypes()
    {
        expectedExt.removeAll()
        let pData = Plist()
        let mData = pData.GetPlistData(plist: "Mime")
        for (key, _) in mData {
           expectedExt.append(key as! String)
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        RemoveBackGroundView()
        GetMimeTypes()
        
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            cTextColour = .red
            labelText = "File Type not allowed"
            AddLabel()
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
        cTextColour = .systemGreen
        labelText = "Drag Files Here to Encrypt"
        AddLabel()
        AddBackGroundView()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
        
    }
    
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else {
                return false
            }
        
        //GET YOUR FILE PATH !!!
        let saveFile = path + ".enc"
        self.filePath = path
        let password = getString(title: "Password Input", question: "Enter your encryption password", defaultValue: "")
        
        if(password.isEmpty)
        {
            self.layer?.backgroundColor = NSColor.red.cgColor
            self.AddBackGroundView()
            return false
        }
        
        labelText = "Processing..."
        AddLabel()
        DispatchQueue.global(qos: .userInitiated).async  //concurrent queue, shared by system
        {
                if let dataRead = NSData(contentsOfFile: path) {
                    
                    //encrypt
                    let encryptor = RNCryptor.Encryptor(password: password)
                    let ciphertext = NSMutableData()
                    
                    ciphertext.append(encryptor.update(withData: dataRead as Data))
                    ciphertext.append(encryptor.finalData())
                    
                    //let ciphertext = RNCryptor.encrypt(data: dataRead as Data, withPassword: password)
                   
                    do {
                        try ciphertext.write(to:  URL(fileURLWithPath: saveFile))
                    } catch {
                        print(error)
                    }
                    let fileManager = FileManager.default
                    
                    do {
                        try fileManager.removeItem(atPath:  self.filePath!)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                }
                
                DispatchQueue.main.async //serial queue
                {
                        self.labelText = "Drag Files Here to Encrypt"
                        self.AddLabel()
                        self.AddBackGroundView()
                }
        }
        
    
        return true
    }
    
    func getString(title: String, question: String, defaultValue: String) -> String {
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = title
        msg.informativeText = question
        
        let txt = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = defaultValue
        
        msg.accessoryView = txt
        let response: NSApplication.ModalResponse = msg.runModal()
        
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            return txt.stringValue
        } else {
            return ""
        }
    }
}


