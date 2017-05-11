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
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func recordAudio(_ sender: UIButton) {
        print("in recordAudio");
        recordLabel.text = "Recording";
        recordButton.isEnabled = false;
        stopButton.isHidden = false;
        
        let session = AVAudioSession.sharedInstance();
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            session.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecording()
                    } else {
                        print("failed to record!")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishedRecording()
        }
    }
    
    func finishedRecording() {
        print("stop recordAudio");
        recordLabel.text = "Tap to record"
        recordButton.isEnabled = true
        stopButton.isHidden = true
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    @IBAction func stopRecordAudio(_ sender: UIButton) {
        finishedRecording()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(pathUrl: recorder.url, titleText: recorder.url.lastPathComponent);
            
            self.performSegue(withIdentifier: "stopRecordingSegue", sender: recordedAudio);
        } else {
            print("error recording");
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error!);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecordingSegue"){
            let playSoundVC:PlaySoundViewController = segue.destination as! PlaySoundViewController
            let data = sender as! RecordedAudio
            
            playSoundVC.receivedAudio = data;
        }
    }
}

