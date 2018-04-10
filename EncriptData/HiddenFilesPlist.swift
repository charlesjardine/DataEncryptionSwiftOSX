//
//  HiddenFilesPlist.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Foundation

class HiddenFilesPlist: NSData {
    
    func SaveToPlist(plist: NSString, fileName: NSString, filePath: NSString)
    {
        var resourceFileDictionary: NSMutableDictionary?
        if let path = Bundle.main.path(forResource: plist as String, ofType: "plist") {
            resourceFileDictionary = NSMutableDictionary(contentsOfFile: path)
        }
        resourceFileDictionary![fileName] = filePath
        
        if let path = Bundle.main.path(forResource: "HiddenFiles", ofType: "plist") {
            
            do {
                try resourceFileDictionary?.write(to: URL(fileURLWithPath: path))
            } catch {
                print(error)
            }
        }
    }
    
    func RemoveFromPlist(plist: NSString, fileName: NSString, filePath: NSString)
    {
        var resourceFileDictionary: NSMutableDictionary?
        if let path = Bundle.main.path(forResource: plist as String, ofType: "plist") {
            resourceFileDictionary = NSMutableDictionary(contentsOfFile: path)
        }
        resourceFileDictionary![fileName] = filePath
        
        if let path = Bundle.main.path(forResource: "HiddenFiles", ofType: "plist") {
            resourceFileDictionary?.removeObject(forKey: fileName)
            do {
                try resourceFileDictionary?.write(to: URL(fileURLWithPath: path))
            } catch {
                print(error)
            }
        }
    }
    
    func GetPlistData(plist: NSString)  -> NSDictionary
    {
        var resourceFileDictionary: NSMutableDictionary?
        if let path = Bundle.main.path(forResource: plist as String, ofType: "plist") {
            resourceFileDictionary = NSMutableDictionary(contentsOfFile: path)
        }
        return resourceFileDictionary!
    }
    
    
}
