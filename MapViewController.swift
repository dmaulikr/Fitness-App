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
    
    // IBOutlets for pauseButton and timerLabel
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pauseText: UIButton!
    
    // Declare timer variables
    var timer = Timer()
    var startTime = 0.0
    var currentTime = 0.0
    var timePassed = 0.0
    var timerActive = false
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start the timer
        activateTimer()
        
        // Show Date
        let currentDate = DateFormatter()
        currentDate.dateStyle = .long
        
        let date = Date()
        let dateToString = currentDate.string(from: date)
        dateLabel.text = dateToString
    }
    
 
    // Activate the timer
    func activateTimer() {
        let dateTimeStart = DateFormatter()
        dateTimeStart.timeStyle = .short
        dateTimeStart.doesRelativeDateFormatting = true
        
        let date = Date()
        let dateToString = dateTimeStart.string(from: date)
        startTimeLabel.text = dateToString
        timer.invalidate()
        startTime = Date().timeIntervalSinceReferenceDate - timePassed
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerActive = true
    }
    
    // Update the timer
    func updateTimer() {
        currentTime = Date().timeIntervalSinceReferenceDate - startTime
        timerLabel.text = timeToString(time: TimeInterval(currentTime))
    }
    
    // Convert timer from Int to String
    func timeToString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Reset the timer
    func clearTimer() {
        timer.invalidate()
        startTime = 0.0
        currentTime = 0.0
        timePassed = 0.0
        timerActive = false
    }
    
    
    // Stop the timer
    @IBAction func stopTimer(_ sender: UIButton) {
        let dateTimeEnd = DateFormatter()
        dateTimeEnd.timeStyle = .short
        dateTimeEnd.doesRelativeDateFormatting = true
        
        let date = Date()
        let dateToString = dateTimeEnd.string(from: date)
        endTimeLabel.text = dateToString
        timer.invalidate()
        timePassed = Date().timeIntervalSinceReferenceDate - startTime
        timerActive = false
    }
    @IBAction func pauseButton(_ sender: UIButton) {
        if (timerActive) {
            timer.invalidate()
            timePassed = Date().timeIntervalSinceReferenceDate - startTime
            pauseText.setTitle("Play", for: .normal)
            timerActive = false
        }
        else {
            activateTimer()
            pauseText.setTitle("Pause", for: .normal)
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
