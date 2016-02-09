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

    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            let url = NSURL.fileURLWithPath(filePath)
            audioPlayer = try! AVAudioPlayer(contentsOfURL: url)
            audioPlayer.enableRate = true
            audioPlayer.rate = 1.0
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        let slowRate: Float = 0.5
        startAudioPlayerAtRate(slowRate)
    }

    @IBAction func playAudioFast(sender: UIButton) {
        let fastRate: Float = 1.5
        startAudioPlayerAtRate(fastRate)
    }
    
    @IBAction func playAudioHighPitch(sender: UIButton) {
//        create an AVAudioEngine object
//        create an AVAudioPlayerNode object
//        attach AVAudioPlayerNode to AVAudioEngine
//        create an AVAudioUnitTimePitch object
//        attach AVAudioUnitTimePitch to AVAudioEngine
//        connect AVAudioPlayerNode to AVAudioUnitTimePitch
//        connect AVAudioUnitTimePitch to an output
//        play the audio file
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Utility Functions
    func startAudioPlayerAtRate(rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }

}
