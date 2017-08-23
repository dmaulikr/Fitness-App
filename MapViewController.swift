//
//  MapViewController.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 8/18/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MapViewController: UIViewController {
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    lazy var coreDataArray = CoreDataArray()
    
    // IBOutlets
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
        currentDate.timeStyle = .long
        let date = Date()
        let dateToString = currentDate.string(from: date)
        dateLabel.text = dateToString
    }
    
 
    // Activate the timer
    func activateTimer() {
        // Show start time
        let dateTimeStart = DateFormatter()
        dateTimeStart.timeStyle = .medium
        dateTimeStart.doesRelativeDateFormatting = true
        let date = Date()
        let dateToString = dateTimeStart.string(from: date)
        startTimeLabel.text = dateToString
        
        // Invalidate timer
        timer.invalidate()
        
        // Calculate start time
        startTime = Date().timeIntervalSinceReferenceDate - timePassed
        
        // Start scheduled timer
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Timer active
        timerActive = true
    }
    
    // Update the timer
    func updateTimer() {
        // Calculate current time
        currentTime = Date().timeIntervalSinceReferenceDate - startTime
        
        // Update timer label
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
        // Show stop time
        let dateTimeEnd = DateFormatter()
        dateTimeEnd.timeStyle = .medium
        dateTimeEnd.doesRelativeDateFormatting = true
        let date = Date()
        let dateToString = dateTimeEnd.string(from: date)
        endTimeLabel.text = dateToString
        
        // Start-end hours
        let startHours = startTimeLabel.text as String?
        let endHours = endTimeLabel.text as String?
        let currentDate = dateLabel.text as String?
        
        // Invalidate timer
        timer.invalidate()
        
        // Calculate time passed
        timePassed = Date().timeIntervalSinceReferenceDate - startTime
        
        // Timer not active
        timerActive = false
        
        // Core data saving
        let context = coreDataModel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseLoop", in: context)
        let exerciseLoop = NSManagedObject(entity: entity!, insertInto: context)
        exerciseLoop.setValue(currentTime, forKeyPath: "time")
        exerciseLoop.setValue(startHours, forKeyPath: "startHours")
        exerciseLoop.setValue(endHours, forKeyPath: "endHours")
        exerciseLoop.setValue(currentDate, forKeyPath: "date")
        exerciseLoop.setValue(counter, forKeyPath: "exerciseID")
        coreDataArray.resultsArray.append(exerciseLoop)
        counter += 1
        coreDataModel.saveContext()
        
        // Segue from Map to Results
        self.performSegue(withIdentifier: "MapToResults", sender: nil)
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        // If timer active, pause
        if (timerActive) {
            // Invalidate timer
            timer.invalidate()
            
            // Calculate time passed
            timePassed = Date().timeIntervalSinceReferenceDate - startTime
            
            // Update button to text, play
            pauseText.setTitle("Play", for: .normal)
            
            // Time not active
            timerActive = false
        }
        // If paused, play
        else {
            // Start timer
            activateTimer()
            
            // Update button to text, pause
            pauseText.setTitle("Pause", for: .normal)
            
            // Timer active
            timerActive = true
        }
    }
    
    // Memory warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
