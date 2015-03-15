//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Markku Liimatainen on 12/03/2015.
//  Copyright (c) 2015 MarkkuL. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled=true
        stopButton.hidden=true
        
        //When user sees this view initially and coming back to it
        recordingInProgress.text = "Tap to record"
        recordingInProgress.hidden = false
        
        //Hide and set appropriate title
        pauseResumeButton.hidden = true
        pauseResumeButton.setTitle("Pause", forState: UIControlState.Normal)
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled=false
        stopButton.hidden=false
        
        recordingInProgress.text = "Recording..."
        recordingInProgress.hidden = false
        pauseResumeButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio=RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled=true
            stopButton.hidden=true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    @IBAction func togglePauseResume(sender: UIButton) {
        if (pauseResumeButton.currentTitle == "Pause"){
            audioRecorder.pause()
            recordingInProgress.hidden = true
            pauseResumeButton.setTitle("Resume", forState: UIControlState.Normal)
        }else{
            
            audioRecorder.record()
            recordingInProgress.hidden = false
            pauseResumeButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden=true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

