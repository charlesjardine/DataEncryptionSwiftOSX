//
//  HideFilesView.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class HideFilesView: NSView {
    
    
    var filePath: String?
    var expectedExt = [""]
    var imageView = NSImageView()
    var labelText = "Drag Files Here to Hide"
    var cBackground = NSColor.black
    var cTextColour = NSColor.systemGreen
    var isMoving = false
    var isBusy = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
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
        imageView = NSImageView(frame: CGRect(x:30,y:20,width:self.bounds.width-60,height:self.bounds.height-60));
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
    
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        if(isBusy)
        {
            return NSDragOperation()
        }
        
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
        if(!isBusy)
        {
            self.layer?.backgroundColor = NSColor.gray.cgColor
            cTextColour = .systemGreen
            labelText = "Drag Files Here to Hide"
            AddLabel()
            AddBackGroundView()
        }
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
        
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        if(isBusy)
        {
            return false
        }
        
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else {
                return false
        }
        
        
        isBusy = true;
        
        
        //GET YOUR FILE PATH !!!
        
        
        labelText = "Processing..."
        AddLabel()
        
        let fileManager = FileManager.default
        
        // Rename 'hello.swift' as 'goodbye.swift'
        
        let fileName = URL(fileURLWithPath: path).lastPathComponent
        let hideName = "." + fileName
        let newPath = path
        let newFile = newPath.replacingOccurrences(of: fileName, with: hideName)
        
        do {
            try fileManager.moveItem(atPath: path, toPath: newFile)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        let d = HiddenFilesModel(fileName: fileName, path: newFile)
        
        let pData = HiddenFilesPlist()
        pData.SaveToPlist(plist: "HiddenFiles", fileName: d.fileName as NSString, filePath: d.path as NSString)
        // plistAC.addObject(d)
        
        //            DispatchQueue.global(qos: .userInitiated).async  //concurrent queue, shared by system
        //                {
        //
        //                    }
        //
        //                    DispatchQueue.main.async //serial queue
        //                        {
        //                            self.labelText = "Drag Files Here to Hide"
        //                            self.AddLabel()
        //                            self.AddBackGroundView()
        //                            self.isBusy = false
        //                    }
        //            }
        
        labelText = "Drag Files Here to Hide"
        AddLabel()
        AddBackGroundView()
        isBusy = false;
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
    
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    func dialogOK(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
}
