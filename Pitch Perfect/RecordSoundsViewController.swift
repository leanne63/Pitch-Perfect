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
	// MARK: - Enums
	enum RecordingStatus {
		case stopped
		case paused
		case recording
	}

    // MARK: - Properties
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var pauseResumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    

	// MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureButtonsForRecordingStatus(.stopped)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if we've stopped the recording, send the recording object over to the "play" view controller
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }


    // MARK: - InterfaceBuilder Actions
    @IBAction func recordAudio(_ sender: UIButton) {
		// configure buttons
		recordButton.isEnabled = false

		recordingLabel.text = "Recording..."

		pauseResumeButton.isHidden = false
		pauseResumeButton.imageView?.image = UIImage(named: "pauseButtonBlue")

		stopButton.isHidden = false

        // set the directory for saving our file - the first one in the search path is the one we want
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        // set up the parts of our file name (so it'll be unique)
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime) + ".wav"
        let filePath = "\(dirPath)/\(recordingName)"
		let fileURL = URL(string: filePath)
        
        // this helps us, as humans, to find the file in case it needs to be manually deleted
        print(filePath)
        
        // start up our audio session and recorder, and begin recording
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: fileURL!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
    }

    @IBAction func stopAudio(_ sender: UIButton) {
        audioRecorder.stop()

        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)

		// configure buttons
		configureButtonsForRecordingStatus(.stopped)

    }

	@IBAction func pauseOrResumeRecording(_ sender: UIButton) {
		if audioRecorder.isRecording {
			configureButtonsForRecordingStatus(.paused)
			audioRecorder.pause()
		}
		else {
			configureButtonsForRecordingStatus(.recording)
			audioRecorder.record()
		}
	}


    // MARK: - AVAudioRecorderDelegate Functions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // recording was successful, so instantiate a recording object
            let filePathURL = recorder.url
            let fileTitle = recorder.url.lastPathComponent
            
            recordedAudio = RecordedAudio(fileURL: filePathURL, fileName: fileTitle)
            
            // send the recorded audio over to the next view controller
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }
        else {
            // recording failed! Let us know and reset the interface appearance appropriately
            print("Recording was not successful!")
            
            recordButton.isEnabled = true
			recordingLabel.text = "Tap to Record"
            stopButton.isHidden = true
			pauseResumeButton.isHidden = true
        }
    }

	// MARK: - Utility Functions
	func configureButtonsForRecordingStatus(_ recordingStatus: RecordingStatus) {
		pauseResumeButton.adjustsImageWhenHighlighted = false

		switch recordingStatus {

		case .stopped:
			recordButton.isEnabled = true

			recordingLabel.text = "Tap to Record"

			stopButton.isHidden = true

			pauseResumeButton.isHidden = true

		case .paused:
			recordButton.isEnabled = false

			recordingLabel.text = "Recording Paused"

			let resumeImage = UIImage(named: "resumeButtonBlue")
			pauseResumeButton.setImage(resumeImage, for: UIControlState())
			pauseResumeButton.isHidden = false

			stopButton.isHidden = false

		case .recording:
			recordButton.isEnabled = false

			recordingLabel.text = "Recording..."

			let resumeImage = UIImage(named: "pauseButtonBlue")
			pauseResumeButton.setImage(resumeImage, for: UIControlState())
			pauseResumeButton.isHidden = false

			stopButton.isHidden = false
			
		}
	}
    
}
