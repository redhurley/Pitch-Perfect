//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Donnie Wang on 8/17/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayerNode: AVAudioPlayerNode!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathURL = NSURL(fileURLWithPath: filePath)
//        } else {
//            println("the filePath is empty")
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        // Audio Engine is initialized
        audioEngine = AVAudioEngine()
        
        // Initialize AVAudioFile() and convert file from NSURL to AVAudioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        stopButton.enabled = true
    }
    
    @IBAction func slowAudioButtonPressed(sender: UIButton) {
        audioPlayer.rate = 0.5
        playAudio()
    }
    
    @IBAction func fastAudioButtonPressed(sender: UIButton) {
        audioPlayer.rate = 2.0
        playAudio()
    }
    
    @IBAction func chipmunkAudioButtonPressed(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderAudioButtonPressed(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        stopButton.enabled = true
        
        // Initialize AVAudioPlayerNode object
        audioPlayerNode = AVAudioPlayerNode()
        // Attach AVAudioPlayerNode object to AVAudioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        // Create AVAudioUnitTimePitch object
        var changePitchEffect = AVAudioUnitTimePitch()
        // Attach AVAudioTimePitch object to AVAudioEngine
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect AVAudioPlayerNode object to AVAudioUnitTimePitch object
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // Connect AVAudioUnitTimePitch to the output (speakers)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        if (audioPlayer.playing) {
            audioPlayer.stop()
        } else {
            audioPlayerNode.stop()
        }
        stopButton.enabled = false
    }
    
}
