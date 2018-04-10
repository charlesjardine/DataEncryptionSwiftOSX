//
//  HiddenFilesLookupViewController.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Cocoa

class HiddenFilesLookupViewController: NSViewController, NSTableViewDelegate {
    var hiddenFiles: NSMutableDictionary!
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var filesAC: NSArrayController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetHiddenFiles()
        tableView.delegate = self
        for (file,path) in hiddenFiles {
            let d = HiddenFilesModel(fileName: file as! String , path: path as! String)
            filesAC.addObject(d)
        }
    }
    
    func GetHiddenFiles()
    {
        //hiddenFiles.removeAll()
        let pData = HiddenFilesPlist()
        hiddenFiles = pData.GetPlistData(plist: "HiddenFiles") as! NSMutableDictionary
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
       let table = notification.object as! NSTableView
       print(hiddenFiles.allKeys[table.selectedRow]);
        
//        for (file,path) in hiddenFiles {
//            print(path)
//        }
    }
    
    
}
