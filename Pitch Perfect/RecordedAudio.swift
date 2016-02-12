//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by leanne on 2/9/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import Foundation

class RecordedAudio {
    let filePathURL: NSURL!
    let title: String!
    
    init(fileURL: NSURL, fileName: String) {
        filePathURL = fileURL
        title = fileName
    }
}