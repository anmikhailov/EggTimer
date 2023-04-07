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
    
    let eggTimes = [
        "Soft": 300,
        "Medium": 420,
        "Hard": 720,
    ]
    
    var secondsPassed = 0
    var secondsTotal = 0
    var timer = Timer()
    var alarmSound: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        if let hardness = sender.currentTitle {
            secondsTotal = eggTimes[hardness] ?? 0
            secondsPassed = 0
            remainingProgressBar.progress = 0.0
            titleLabel.text = hardness
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(updateCounter),
                userInfo: nil,
                repeats: true)
        }

    }
    
    @objc func updateCounter() {
        if secondsPassed < secondsTotal {
            secondsPassed += 1
            print("\(secondsPassed) seconds passed")
            remainingProgressBar.progress = Float(secondsPassed) / Float(secondsTotal)
        } else {
            timer.invalidate()
            titleLabel.text = "Done!"
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

