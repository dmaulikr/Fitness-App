//
//  WorkoutDetailViewController.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 8/26/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WorkoutDetailViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var exerciseIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startHoursLabel: UILabel!
    @IBOutlet weak var endHoursLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepsLabel: CircleLabelView!
    @IBOutlet weak var distanceLabel: CircleLabelView!
    @IBOutlet weak var averageSpeedLabel: CircleLabelView!
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    
    // Declare array to store entities as NSManagedObjects
    var results: [NSManagedObject] = []
    var result: NSManagedObject?
    
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access core data context
        let context = coreDataModel.persistentContainer.viewContext
        
        // Create fetch request to update new table data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseLoop")

        
        // Sort descriptors for sorting the table view
        let sortDescriptorDate = NSSortDescriptor(key: "date", ascending: false,
                                                  selector: #selector(NSString.localizedStandardCompare))
        fetchRequest.sortDescriptors = [sortDescriptorDate]
        
        // try to fetch ExerciseLoop context from data model and store in results array
        do {
            results = try context.fetch(fetchRequest) as! [ExerciseLoop]
            
            if (resultsToWorkoutDetail) {
                result = self.results[rowClicked!]
                resultsToWorkoutDetail = false
            }
            else {
                result = self.results[0]
                exerciseIDLabel.text = "Workout " + String(describing: result?.value(forKeyPath: "exerciseID")!)
            }
            
            // Update Labels
            exerciseIDLabel.text = "Workout " + String(describing: result!.value(forKeyPath: "exerciseID")!)
            dateLabel.text = " Date: " + String(describing: result!.value(forKeyPath: "dateShort")!)
            startHoursLabel.text = " Start Hours: " + String(describing: result!.value(forKeyPath: "startHours")!)
            endHoursLabel.text = " End Hours: " + String(describing: result!.value(forKeyPath: "endHours")!)
            let timeVal = result!.value(forKeyPath: "time")
            timeLabel.text = " Time: " + timeToString(time: timeVal as! TimeInterval)
            stepsLabel.text = " Steps: " + String(describing: result!.value(forKeyPath: "steps")!)
            distanceLabel.text = " Distance: " + String(describing: result!.value(forKeyPath: "distance")!) + " miles"
            averageSpeedLabel.text = " Average Speed: " + String(describing: result!.value(forKeyPath: "averageSpeed")!)
        } catch {
            fatalError("Failed to fetch exercise loops: \(error)")
        }

        
    }
    
    // Convert timer from Int to String
    func timeToString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02d hours %02d minutes %02d seconds", hours, minutes, seconds)
    }
    
    
    @IBAction func HomeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "WorkoutDetailToHome", sender: nil)
    }
    
    @IBAction func BackTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "WorkoutDetailToResults", sender: nil)
    }
   
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
