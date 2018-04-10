//
//  HiddenFilesModel.swift
//  Data Encription
//
//  Created by Charles Jardine on 10/04/2018.
//  Copyright © 2018 Charles Jardine. All rights reserved.
//

import Foundation
@objc(HiddenFilesModel)
class HiddenFilesModel : NSObject
{
    @objc var fileName: String
    @objc var path: String
    
    init(fileName: String,path: String) {
        self.fileName = fileName
        self.path = path
    }
}
