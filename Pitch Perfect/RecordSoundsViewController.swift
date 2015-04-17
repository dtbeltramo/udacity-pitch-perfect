//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dustin Beltramo on 4/7/15.
//  Copyright (c) 2015 Dustin Beltramo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var statusLabel2: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    let resumeButtonImage = UIImage(named: "resume") as UIImage?
    let pauseButtonImage = UIImage(named: "pause") as UIImage?
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        stopRecording.hidden = true
        pauseResumeButton.hidden = true
        recordButton.enabled = true
        statusLabel2.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func recordAudio(sender: UIButton) {
        stopRecording.hidden = false
        pauseResumeButton.hidden = false
        recordButton.enabled = false
        statusLabel2.text = "Recording..."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            //Move to the next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("The recording was not saved successfully.")
            recordButton.enabled = true
            stopRecording.hidden = true
            pauseResumeButton.hidden = true
            statusLabel2.text = "Tap the microphone to record your voice"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        pauseResumeButton.hidden = true
        statusLabel2.hidden = true
        statusLabel2.text = "Tap the microphone to record your voice"
        recordButton.enabled = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        
    }

    @IBAction func pauseResumeRecording(sender: UIButton) {
        if audioRecorder.recording == true {
            pauseResumeButton.setImage(resumeButtonImage, forState: UIControlState.Normal)
            statusLabel2.text = "Recording paused"
            audioRecorder.pause()
        } else {
            pauseResumeButton.setImage(pauseButtonImage, forState: UIControlState.Normal)
            statusLabel2.text = "Recording..."
            audioRecorder.record()
        }
    }
}

