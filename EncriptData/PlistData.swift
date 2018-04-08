//
//  PlistData.swift
//  Data Encription
//
//  Created by Charles Jardine on 05/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Foundation
@objc(PlistData)
class PlistData : NSObject
{
    @objc var key: String
    @objc var value: String
    
    init(key: String,value: String) {
        self.key = key
        self.value = value
    }
}
