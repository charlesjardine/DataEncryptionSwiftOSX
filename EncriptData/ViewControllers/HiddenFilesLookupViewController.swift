//
//  HiddenFilesLookupViewController.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class HiddenFilesLookupViewController: NSViewController, NSTableViewDelegate {
    
    class func loadFromNib() -> HiddenFilesLookupViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "HiddenFilesLookupViewController")) as! HiddenFilesLookupViewController
    }
    
    var hiddenFiles: NSMutableDictionary!
    var selectedFile: String = ""
    var isBusy = false;
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var filesAC: NSArrayController!
    @IBAction func btnRestore(_ sender: Any) {
     
        SetShowFiles()
        
        let fileName = URL(fileURLWithPath: selectedFile).lastPathComponent
        let path = selectedFile.replacingOccurrences(of: fileName, with: "")

        let c = fileName
        let range = c.index(c.startIndex, offsetBy: 1)..<c.endIndex
        let newFile = fileName[range]
        let newPath = path + newFile

        print(selectedFile)
        print(newPath)

        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: selectedFile, toPath: newPath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        SetHideFiles()
        
        let pData = HiddenFilesPlist()
        pData.RemoveFromPlist(plist: "HiddenFiles", fileName: newFile as NSString, filePath: newPath as NSString)
        ReloadData()
    }
    
    func SetHideFiles()
    {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "FALSE"]
        task.launch()
        task.waitUntilExit()
    }
    
    func SetShowFiles()
    {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "TRUE"]
        task.launch()
        task.waitUntilExit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        //tableView.doubleAction = #selector(tableViewDoubleClick(_:))
    }
    
    

    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        
        guard tableView.selectedRow >= 0,
            let item = hiddenFiles[tableView.selectedRow] else {
                return
        }
        if ((item as AnyObject).path != nil) {
            
            print(item)
        }
    }
    
    override func viewWillAppear() {
        
        ReloadData()
    }
    
    func ReloadData()
    {
        isBusy = true
        if(hiddenFiles != nil)
        {
            filesAC.content = nil
            hiddenFiles.removeAllObjects()
        }
        tableView.reloadData()
        
        GetHiddenFiles()
        for (file,path) in hiddenFiles {
            let d = HiddenFilesModel(fileName: file as! String , path: path as! String)
            filesAC.addObject(d)
        }
        tableView.selectRowIndexes(NSIndexSet(index: 0) as IndexSet, byExtendingSelection: false)
        isBusy = false
    }
    
    func GetHiddenFiles()
    {
        hiddenFiles = nil
        let pData = HiddenFilesPlist()
        hiddenFiles = pData.GetPlistData(plist: "HiddenFiles") as! NSMutableDictionary
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if(!isBusy)
        {
            let table = notification.object as! NSTableView
           
            if(hiddenFiles.count <= table.selectedRow+1)
            {
               selectedFile = Array(hiddenFiles)[table.selectedRow].value as! String
               print(selectedFile)
            }
        }
        
    }
    
    
}
