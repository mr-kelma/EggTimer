//
//  ViewController.swift
//  EggTimer
//
//  Created by Valery Keplin on 7.06.22.
//

import UIKit
import AVFoundation

var player: AVAudioPlayer!
var timer = Timer()
var totalTime = 0
var secondsPassed = 0
var secondsLeft = 0
var progress: Float = 0
let eggTime = ["Soft":4, "Medium":8, "Hard":12]
//starting conditions

class ViewController: UIViewController {
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var activityViewSoft: UIActivityIndicatorView!
    @IBOutlet weak var activityViewMedium: UIActivityIndicatorView!
    @IBOutlet weak var activityViewHard: UIActivityIndicatorView!
    @IBOutlet weak var markerOfSoft: UILabel!
    @IBOutlet weak var markerOfMedium: UILabel!
    @IBOutlet weak var markerOfHard: UILabel!
    @IBOutlet weak var timerView: UILabel!
    @IBOutlet weak var secondsView: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    //activation labels and progress line
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityViewSoft.alpha = 0
        activityViewMedium.alpha = 0
        activityViewHard.alpha = 0
        markerOfSoft.alpha = 0
        markerOfMedium.alpha = 0
        markerOfHard.alpha = 0
        timerView.alpha = 0
        secondsView.alpha = 0
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        titelLabel.text = "Ждём..."
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        //timer creation
        
        let hardness = sender.currentTitle!
        //hardness assignment
        
        totalTime = eggTime[hardness]!
        //cooking time assignment
        
        timerView.alpha = 0.8
        secondsView.alpha = 0.8
        secondsLeft = totalTime
        timerView.text = "\(secondsLeft)"
        
        progress = Float(eggTime[hardness]!)
        progressView.progress = 0
        secondsPassed = 0
        //initial cooking progress
        
        switch hardness {
        case "Soft":
            markerOfSoft.alpha = 1; activityViewSoft.alpha = 1; markerOfMedium.alpha = 0; activityViewMedium.alpha = 0; markerOfHard.alpha = 0; activityViewHard.alpha = 0
        case "Medium":
            markerOfSoft.alpha = 0; activityViewSoft.alpha = 0; markerOfMedium.alpha = 1; activityViewMedium.alpha = 1; markerOfHard.alpha = 0; activityViewHard.alpha = 0
        case "Hard":
            markerOfSoft.alpha = 0; activityViewSoft.alpha = 0; markerOfMedium.alpha = 0; activityViewMedium.alpha = 0; markerOfHard.alpha = 1; activityViewHard.alpha = 1
        default:
            print("ErrorMarker")
        } //fixing the hardness choice
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            secondsLeft -= 1
            timerView.text = "\(secondsLeft)"
            progressView.progress = progressView.progress + 1/progress
            //progress meter
            
        } else {
            playAlarm()
            //finish signal
            
            titelLabel.text = "Яичко готово, можно кушать!"
            //finish label in the top screen
            
            activityViewSoft.alpha = 0
            activityViewMedium.alpha = 0
            activityViewHard.alpha = 0
            timerView.alpha = 0
            secondsView.alpha = 0
            //invisible activityView
            
            timer.invalidate()
            //timer zeroing
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.titelLabel.text = "Может добавки? Выбирай степень"
                //new label in the top screen
                self.markerOfSoft.alpha = 0; self.markerOfMedium.alpha = 0; self.markerOfHard.alpha = 0; self.progressView.progress = 0
            }
        }
    }
}

func playAlarm() {
    let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "wav")
    player = try! AVAudioPlayer(contentsOf: url!)
    player.play()
} //player finish signal
