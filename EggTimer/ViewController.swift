//
//  ViewController.swift
//  EggTimer
//
//  Created by Andrey on 07.04.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remainingProgressBar: UIProgressView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    let eggTimes = [
        "Soft": 300,
        "Medium": 420,
        "Hard": 720,
    ]
    
    var secondsPassed = 0
    var secondsTotal = 0
    var timer = Timer()
    var alarmSound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.isHidden = true
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        if let hardness = sender.currentTitle {
            
            secondsTotal = eggTimes[hardness] ?? 0
            secondsPassed = 0
            remainingProgressBar.progress = 0.0
            
            remainingTimeLabel.text = String(format: "%02d", (secondsTotal - secondsPassed) / 60) + ":" + String(format: "%02d", (secondsTotal - secondsPassed) % 60)
            
            titleLabel.text = hardness
            cancelButton.isHidden = false
            remainingTimeLabel.isHidden = false
            
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(updateCounter),
                userInfo: nil,
                repeats: true)
        }

    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        timer.invalidate()
        remainingTimeLabel.isHidden = true
        cancelButton.isHidden = true
        remainingProgressBar.progress = 0.0
        titleLabel.text = "How do you like your eggs?"
        
    }
    
    @objc func updateCounter() {
        if secondsPassed < secondsTotal {
            secondsPassed += 1
            
            let minutesRemaning = (secondsTotal - secondsPassed) / 60
            let secondsRemainig = (secondsTotal - secondsPassed) % 60

            remainingProgressBar.progress = Float(secondsPassed) / Float(secondsTotal)
            remainingTimeLabel.text = String(format: "%02d", minutesRemaning) + ":" + String(format: "%02d", secondsRemainig)
        } else {
            timer.invalidate()
            titleLabel.text = "Done!"
            cancelButton.isHidden = true
            remainingTimeLabel.isHidden = true
            playAlarmSound()
        }
    }
    
    func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension:"mp3") else
        { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            alarmSound = try AVAudioPlayer(contentsOf: url)
            alarmSound?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

