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
import CoreMotion

var counter: Int16?
var pedometer = CMPedometer()

class MapViewController: UIViewController {
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    
    // Declare array to store entities as NSManagedObjects
    var results: [NSManagedObject] = []
    
    // IBOutlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pauseText: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    // Declare timer variables
    var timer = Timer()
    var startTime = 0.0
    var currentTime = 0.0
    var timePassed = 0.0
    var timerActive = false
    
    // Declare date variables
    var dateShortString: String?
    var startHours: String?
    var endHours: String?
    var currentDate: String?
    
    // Declare motion variables
    var steps: Int? = nil
    var distance: Double? = nil
    var speed: Double? = nil
    var averageSpeed: Double? = nil
    
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start the timer
        activateTimer()
        
        // Start the pedometer
        activatePedometer()
        
        // Show Date
        let currentDateFormat = DateFormatter()
        currentDateFormat.dateStyle = .long
        currentDateFormat.timeStyle = .long
        let date = Date()
        currentDate = currentDateFormat.string(from: date)
        dateLabel.text = currentDate
        
        let currentDateShort = DateFormatter()
        currentDateShort.dateStyle = .long
        dateShortString = currentDateShort.string(from: date)
    }
    
 
    // Activate the timer
    func activateTimer() {
        // Show start time
        let dateTimeStart = DateFormatter()
        dateTimeStart.timeStyle = .medium
        dateTimeStart.doesRelativeDateFormatting = true
        let date = Date()
        startHours = dateTimeStart.string(from: date)
        startTimeLabel.text = startHours
        
        // Invalidate timer
        timer.invalidate()
        
        // Calculate start time
        startTime = Date().timeIntervalSinceReferenceDate - timePassed
        
        // Start scheduled timer
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Timer active
        timerActive = true
    }
    
    // Activate the pedometer
    func activatePedometer() {
        pedometer.startUpdates(from: Date(), withHandler: {
            (data: CMPedometerData?, error: Error?) -> Void in
            if let data = data {
//                self.steps = data.numberOfSteps as Int?
//                self.distance = data.distance as Double?
//                self.speed = data.currentPace as Double?
//                self.averageSpeed = data.averageActivePace as Double?
                
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if (error == nil)
                    {
                        self.steps = data.numberOfSteps as Int?
                        self.distance = data.distance as Double?
                        self.speed = data.currentPace as Double?
                        self.averageSpeed = data.averageActivePace as Double?
                        
                        if (self.steps != nil) {
                            self.stepsLabel.text = String(format: "Steps: %i", self.steps!)
                            UILabel.transition(with: self.stepsLabel, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        }
                        if (self.distance != nil) {
                            self.distanceLabel.text = String(format: "%d miles", self.metersToMiles(meters: self.distance!))
                            UILabel.transition(with: self.distanceLabel, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        }
                        if (self.averageSpeed != nil) {
                            self.averageSpeedLabel.text = self.minutesPerMile(pace: self.averageSpeed!)
                            UILabel.transition(with: self.averageSpeedLabel, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        }
                        if (self.speed != nil) {
                            self.speedLabel.text = self.minutesPerMile(pace: self.speed!)
                            UILabel.transition(with: self.speedLabel, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        }

                    }
                    else {
                        print(error!)
                    }
                }
            )
            }
        })
    }
    
    func metersToMiles(meters: Double) -> Double {
        //let mileRatio = 0.000621371
        let mileRatio = 1609.344
        let miles: Double = meters / mileRatio
        return miles
    }
    
    func minutesPerMile(pace: Double) -> String {
        var conversion = 0.0
        let conversionRatio = 26.8224
        if pace != 0 {
            conversion = conversionRatio / pace
        }
        let minutes = Int(conversion)
        let seconds = Int(conversion * 60) % 60
        return String(format: "%02d:%02d minutes/mile", minutes, seconds)
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
        endHours = dateTimeEnd.string(from: date)
        endTimeLabel.text = endHours
        
        // Invalidate timer
        timer.invalidate()
        
        // Calculate time passed
        timePassed = Date().timeIntervalSinceReferenceDate - startTime
        
        // Timer not active
        timerActive = false
        
        // Access core data context
        let context = coreDataModel.persistentContainer.viewContext
        
        // Create fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseLoop")
        
        // Store results from fetch request in results array
        do {
            results = try context.fetch(fetchRequest)
            // Set counter to 1 initially, otherwise increase counter by 1
            if (results.count == 0) {
                counter = 1
            }
            else {
                counter = counter! + 1
            }
        } catch {
            fatalError("Failed to fetch exercise loops: \(error)")
        }
        
        // Core data saving
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseLoop", in: context)
        let exerciseLoop = NSManagedObject(entity: entity!, insertInto: context)
        exerciseLoop.setValue(currentTime, forKeyPath: "time")
        exerciseLoop.setValue(startHours, forKeyPath: "startHours")
        exerciseLoop.setValue(endHours, forKeyPath: "endHours")
        exerciseLoop.setValue(currentDate, forKeyPath: "date")
        exerciseLoop.setValue(dateShortString, forKey: "dateShort")
        exerciseLoop.setValue(counter!, forKeyPath: "exerciseID")
        coreDataModel.saveContext()
        
        // Segue from Map to WorkoutDetail
        self.performSegue(withIdentifier: "MapToWorkoutDetail", sender: nil)
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        // If timer active, pause
        if (timerActive) {
            // Invalidate timer
            timer.invalidate()
            
            // Stop the pedometer
            pedometer.stopUpdates()
            
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
            
            // Start pedomter
            activatePedometer()
            
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
