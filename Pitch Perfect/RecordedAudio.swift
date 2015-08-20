//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Donnie Wang on 8/18/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathURL: NSURL
    var title: String
    
    init (filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}