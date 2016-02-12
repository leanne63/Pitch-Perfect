//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by leanne on 1/19/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Global Variables
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if we've stopped the recording, send the recording object over to the "play" view controller
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // MARK: - InterfaceBuilder Actions
    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        // set the directory for saving our file - the first one in the search path is the one we want
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // set up the parts of our file name (so it'll be unique)
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // this helps us, as humans, to find the file in case it needs to be manually deleted
        print(filePath)
        
        // start up our audio session and recorder, and begin recording
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    // MARK: - AVAudioRecorderDelegate Functions
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // recording was successful, so instantiate a recording object
            let filePathURL = recorder.url
            let fileTitle = recorder.url.lastPathComponent
            
            recordedAudio = RecordedAudio(fileURL: filePathURL, fileName: fileTitle!)
            
            // send the recorded audio over to the next view controller
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            // recording failed! Let us know and reset the interface appearance appropriately
            print("Recording was not successful!")
            
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
}

