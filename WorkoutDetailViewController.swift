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
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    
    // Declare array to store entities as NSManagedObjects
    var results: [NSManagedObject] = []
    
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
                let result = self.results[rowClicked!]
                exerciseIDLabel.text = "Workout " + String(describing: result.value(forKeyPath: "exerciseID")!)
                resultsToWorkoutDetail = false
            }
            else {
                let result = self.results[0]
                exerciseIDLabel.text = "Workout " + String(describing: result.value(forKeyPath: "exerciseID")!)
            }
        } catch {
            fatalError("Failed to fetch exercise loops: \(error)")
        }

        
    }
    
    
    @IBAction func HomeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "WorkoutDetailToHome", sender: nil)
    }
   
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
