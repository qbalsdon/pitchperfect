//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Quintin Balsdon on 2015/07/25.
//  Copyright (c) 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var audioPlayerNode : AVAudioPlayerNode!
    var darthBackTrack : AVAudioPlayer!
    var interval : NSTimeInterval!
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil);
        
        audioEngine = AVAudioEngine();
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil);
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        interval = audioPlayer.duration + 2;
        audioPlayer.enableRate = true;
        
        if var darthFP = NSBundle.mainBundle().pathForResource("Darth-vader-breathing", ofType: "wav"){
            var darthUrl = NSURL.fileURLWithPath(darthFP);
            darthBackTrack = AVAudioPlayer(contentsOfURL: darthUrl, error: nil);
            darthBackTrack.volume = 0.05;
            darthBackTrack.numberOfLoops = 100;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stopAll(){
        audioEngine.reset();
        darthBackTrack.stop();
        audioPlayer.stop();
        audioEngine.stop();
        if (audioPlayerNode != nil){
            audioPlayerNode.stop();
        }
        
        if(timer != nil){
            timer.invalidate();
            timer = nil;
        }
        
        darthBackTrack.currentTime = 0.0;
        audioPlayer.currentTime = 0.0;
    }
    
    func play(rate:Float){
        stopAll();
        audioPlayer.rate = rate;
        audioPlayer.play();
    }
    
    func playPitch(pitch: Float) {
        stopAll();
        audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attachNode(audioPlayerNode);
        
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        audioEngine.attachNode(changePitchEffect);
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil);
        audioEngine.startAndReturnError(nil);
        
        audioPlayerNode.volume = 100;
        audioPlayerNode.play();
        println("delay: \(interval)");
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: Selector("stopAll"), userInfo: nil, repeats: false);
    }
    
    @IBAction func slowButton(sender: UIButton) {
        play(0.5);
    }
    
    @IBAction func fastButton(sender: UIButton) {
        play(1.5);
    }
    
    @IBAction func chipmunkButton(sender: UIButton) {
        playPitch(1000);
    }
    
    @IBAction func darthVaderButton(sender: UIButton) {
        playPitch(-1000);
        darthBackTrack.play();
    }
    
    
    @IBAction func stopButton(sender: UIButton) {
        stopAll();
    }
}
