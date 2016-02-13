//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by leanne on 1/28/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: - Global Variables
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:  AVAudioFile!
    
    // MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up our audio player, engine, and recording, so ready to play user selection
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        audioPlayer.rate = 1.0
        
        audioEngine = AVAudioEngine()
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        let slowRate: Float = 0.5
        playAudioAtRate(slowRate)
    }

    // MARK: - InterfaceBuilder Actions
    @IBAction func playAudioFast(sender: UIButton) {
        let fastRate: Float = 1.5
        playAudioAtRate(fastRate)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioAtPitch(1000.0)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioAtPitch(-1000.0)
    }
    
	@IBAction func playReverbAudio(sender: UIButton) {
		resetAudio()

		// set up audio player node
		let audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attachNode(audioPlayerNode)

		// set up reverb effect node
		let reverbEffect = AVAudioUnitReverb()
		reverbEffect.loadFactoryPreset(.Cathedral)
		reverbEffect.wetDryMix = 25
		audioEngine.attachNode(reverbEffect)

		// connect nodes to each other through audio engine
		audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
		audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)

		// schedule the recording to play
		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

		// start the engine and play the audio
		try! audioEngine.start()

		audioPlayerNode.play()

	}

	@IBAction func playEchoAudio(sender: UIButton) {
		resetAudio()

		// set up audio player node
		let audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attachNode(audioPlayerNode)

		// set up delay node
		let delayUnit = AVAudioUnitDelay()
		delayUnit.wetDryMix = 0.0
		audioEngine.attachNode(delayUnit)

		// set up reverb effect node
		let reverbEffect = AVAudioUnitReverb()
		reverbEffect.loadFactoryPreset(.Cathedral)
		reverbEffect.wetDryMix = 25.0
		audioEngine.attachNode(reverbEffect)

		// connect nodes to each other through audio engine
		audioEngine.connect(audioPlayerNode, to: delayUnit, format: nil)
		audioEngine.connect(delayUnit, to: reverbEffect, format: nil)
		audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)

		// schedule the recording to play
		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

		// start the engine and play the audio
		try! audioEngine.start()

		audioPlayerNode.play()
		
	}
    @IBAction func stopSound(sender: UIButton) {
        resetAudio()
    }
    
    // MARK: - Utility Functions
    /**
    Stops and resets audio player and engine.
    */
    func resetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /**
        Plays audio at specified rate.
        
        - Parameter rate: Speed at which to play audio.
     */
    func playAudioAtRate(rate: Float) {
        resetAudio()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        
        audioPlayer.play()
    }
    
    /**
        Plays audio at specified pitch.
     
        - Parameter pitchVal: Pitch at which to play audio.
     */
    func playAudioAtPitch(pitchVal:Float) {
        resetAudio()
        
		// set up audio player node
		let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
		// set up pitch effect node
		let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitchVal
        audioEngine.attachNode(pitchEffect)
        
		// connect nodes to each other through audio engine
		audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
		// schedule the recording to play
		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
		// start the engine and play the audio
		try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
}
