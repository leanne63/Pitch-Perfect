//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by leanne on 2/9/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import Foundation

/// An audio recording.
class RecordedAudio {

    // MARK: - Global Variables
    let filePathURL: NSURL!
    let title: String!
    
    // MARK: - Init Functions
    /**
    Initializes an audio recording with the specified file path (URL) and file name.
    
    - Parameter fileURL: URL path of file containing an audio recording.
    - Parameter fileName: Name of file represented by fileURL.
    
    - Returns: An audio recording.
    */
    init(fileURL: NSURL, fileName: String) {
        filePathURL = fileURL
        title = fileName
    }
}