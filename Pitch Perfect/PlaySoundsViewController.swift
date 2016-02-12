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
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:  AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        audioPlayer.rate = 1.0
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        resetAudio()
        let slowRate: Float = 0.5
        playAudioAtRate(slowRate)
    }

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
    
    @IBAction func stopSound(sender: UIButton) {
        resetAudio()
    }
    
    // MARK: - Utility Functions
    func playAudioAtRate(rate: Float) {
        resetAudio()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioAtPitch(pitchVal:Float) {
        resetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitchVal
        audioEngine.attachNode(pitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    func resetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
