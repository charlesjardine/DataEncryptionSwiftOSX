//
//  Plist.swift
//  Data Encription
//
//  Created by Charles Jardine on 05/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//
import Foundation

class Plist: NSData {
    
    func SaveToPlist(plist: NSString, key: NSString,value: NSString)
    {
        var resourceFileDictionary: NSMutableDictionary?
        if let path = Bundle.main.path(forResource: plist as String, ofType: "plist") {
            resourceFileDictionary = NSMutableDictionary(contentsOfFile: path)
        }
        resourceFileDictionary![key] = value
       
        if let path = Bundle.main.path(forResource: "Mime", ofType: "plist") {
        
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
