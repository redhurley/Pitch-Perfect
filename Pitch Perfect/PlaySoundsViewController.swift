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
    
    var audioEngine: AVAudioEngine!
    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    
    var audioPlayerNode: AVAudioPlayerNode!
    var reverbEffect: AVAudioUnitReverb!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathURL = NSURL(fileURLWithPath: filePath)
//        } else {
//            println("the filePath is empty")
//        }
        
        audioEngine = AVAudioEngine()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer2.enableRate = true
        
        // Initialize AVAudioFile() and convert file from NSURL to AVAudioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio() {
        stopAllPlayers()
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
    
    @IBAction func reverbAudioButtonPressed(sender: UIButton) {
        stopAllPlayers()
        
        audioPlayerNode = AVAudioPlayerNode()
        
        // Attach AVAudioPlayerNode object to AVAudioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        reverbEffect = AVAudioUnitReverb()
        
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        reverbEffect.wetDryMix = 50.0
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        stopButton.enabled = true
    }
    
    @IBAction func echoAudioButtonPressed(sender: UIButton) {
        stopAllPlayers()
        playAudio()
        
        audioPlayer2.currentTime = 0.0
        audioPlayer2.volume = 0.8
        let delay: NSTimeInterval = 0.1
        audioPlayer2.playAtTime(audioPlayer2.deviceCurrentTime + delay)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllPlayers()
        audioEngine.reset()
        
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
        stopButton.enabled = true
    }
    
    func stopAllPlayers() {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        stopAllPlayers()
        stopButton.enabled = false
    }
}
