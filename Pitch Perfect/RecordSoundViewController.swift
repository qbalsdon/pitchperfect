//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Quintin Balsdon on 2015/07/25.
//  Copyright (c) 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio");
        recordLabel.text = "Recording";
        recordButton.enabled = false;
        stopButton.hidden = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String;
        
        let recordingName = "myvoice.wav";
        let pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        println(filePath);
        
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryRecord, error: nil);
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil);
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record();
        
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        println("stop recordAudio");
        recordLabel.text = "Tap to record"
        recordButton.enabled = true;
        stopButton.hidden = true;
        audioRecorder?.stop();
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(pathUrl: recorder.url, titleText: recorder.url.lastPathComponent);
            
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio);
        } else {
            println("error recording");
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println(error);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue"){
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            
            playSoundVC.receivedAudio = data;
        }
    }
}

