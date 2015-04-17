//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Dustin Beltramo on 4/13/15.
//  Copyright (c) 2015 Dustin Beltramo. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
