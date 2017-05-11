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
    var interval : TimeInterval!
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback);
        

            try audioFile = AVAudioFile(forWriting: receivedAudio.filePathUrl as URL, settings:[:]);
        
        try audioPlayer = AVAudioPlayer(contentsOf: receivedAudio.filePathUrl);
        interval = audioPlayer.duration + 2;
        audioPlayer.enableRate = true;
        
        if let darthFP = Bundle.main.path(forResource: "Darth-vader-breathing", ofType: "wav"){
            let darthUrl = URL(fileURLWithPath: darthFP);
            try darthBackTrack = AVAudioPlayer(contentsOf: darthUrl);
            darthBackTrack.volume = 0.05;
            darthBackTrack.numberOfLoops = 100;
        }
        } catch {
            print("Error in playback")
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
    
    func play(_ rate:Float){
        stopAll();
        audioPlayer.rate = rate;
        audioPlayer.play();
    }
    
    func playPitch(_ pitch: Float) {
        do {
        stopAll();
        audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attach(audioPlayerNode);
        
        let changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        audioEngine.attach(changePitchEffect);
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil);
        try audioEngine.start();
        
        audioPlayerNode.volume = 100;
        audioPlayerNode.play();
        print("delay: \(interval)");
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(PlaySoundViewController.stopAll), userInfo: nil, repeats: false);
        } catch {
            print("Error in playback")
        }
    }
    
    @IBAction func slowButton(_ sender: UIButton) {
        play(0.5);
    }
    
    @IBAction func fastButton(_ sender: UIButton) {
        play(1.5);
    }
    
    @IBAction func chipmunkButton(_ sender: UIButton) {
        playPitch(1000);
    }
    
    @IBAction func darthVaderButton(_ sender: UIButton) {
        playPitch(-1000);
        darthBackTrack.play();
    }
    
    
    @IBAction func stopButton(_ sender: UIButton) {
        stopAll();
    }
}
