//
//  RecordSoundsViewController.swift
//  test
//
//  Created by Guido Roos on 21/04/2023.
//
import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func stopRecording(_ sender: Any) {
        setupUi(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        setupUi(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func setupUi (isRecording:Bool) {
        recordingLabel.text = isRecording ? "Recording" : "Tap to Record"
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled  = !isRecording
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    
        } else {
            print ("something wrong")
        }
    }
    
    override func prepare(for seque: UIStoryboardSegue, sender:Any?) {
        if seque.identifier == "stopRecording" {
            let playSoundsVC = seque.destination as! PlaySoundsViewController
            let recorderAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recorderAudioURL
        }
    }
}
