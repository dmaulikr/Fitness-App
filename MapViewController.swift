//
//  MapViewController.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 8/18/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    
    // Declare variables
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    var counter = 0.0
    var seconds = 60
    var timer = Timer()
    let date = Date()
    var timerActive = false
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start the timer
        activateTimer()
        timerActive = true
    }
    
    // Activate the timer
    func activateTimer() {
        self.timer = Timer(fireAt: date,
                           interval: 0.01,
                           target: self,
                           selector: #selector(updateTimer(timer:)),
                           userInfo: nil,
                           repeats: true)
        
        RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
        self.timer.fire()
    }
    
    // Update the timer
    func updateTimer(timer: Timer!) {
        seconds += 1
        timerLabel.text = timeToString(time: TimeInterval(seconds))
    }
    
    // Convert timer from Int to String
    func timeToString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Reset the timer
    @IBAction func clearTimer(_ sender: UIButton) {
        timer.invalidate()
        seconds = 0
        timerLabel.text = timeToString(time: TimeInterval(seconds))
        seconds = 60
    }
    
    
    // Stop the timer
    @IBAction func stopTimer(_ sender: UIButton) {
        if (timerActive) {
            timer.invalidate()
            pauseButton.setTitle("Resume", for: .normal)
            timerActive = false
        }
        else {
            activateTimer()
            pauseButton.setTitle("Pause", for: .normal)
            timerActive = true
        }
    }
    

    // Transition from Map View to Main View
    @IBAction func BackTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMain", sender: nil)
    }
    
    // Memory warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
