//
//  ResultsViewController.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 8/20/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ResultsViewController: UITableViewController {
    
    // Table view
    @IBOutlet var ResultsTableView: UITableView!
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    
    // Declare array to store entities as NSManagedObjects
    var results: [NSManagedObject] = []
    
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Appear view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access core data context
        let context = coreDataModel.persistentContainer.viewContext
        
        // Create fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseLoop")
        
        // Sort descriptors for sorting the table view
        let sortDescriptorDate = NSSortDescriptor(key: "date", ascending: false,
                                              selector: #selector(NSString.localizedStandardCompare))

        fetchRequest.sortDescriptors = [sortDescriptorDate]
        
        // Store results from fetch request in results array
        do {
            results = try context.fetch(fetchRequest)
            print("number of results: \(results.count)")
            
            for result in results as! [ExerciseLoop] {
                print("\(result.exerciseID)")
                print("\(result.time)")
            }
        } catch {
            fatalError("Failed to fetch exercise loops: \(error)")
        }
        
        // Reload table view data
        ResultsTableView.reloadData()
    }
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table view number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Table view number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    // Table view cell for row at
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Cell indentifier
        let cellIdentifier = "ExerciseIDViewCell"
        
        // Dequeue reusuable cell with cell identifier at index path
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExerciseIDViewCell
        
        // Check cell for nil
        if cell == nil {
            // Assign cell to the cell identifier
            cell = ExerciseIDViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        
        // Fetches exercise loop at specific indexPath row
        let result = results[indexPath.row]
        
        // Show label with results
        cell?.ExerciseIDLabel.text = "Workout " + String(describing: result.value(forKeyPath: "exerciseID")!)
        cell?.ExerciseIDSubtitle.text = result.value(forKeyPath: "date") as? String
        
        return cell!
    }
    
    // Deleting a workout
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let workoutToDelete = results[indexPath.row]
            
            for result in results as! [ExerciseLoop] {
                if (result == workoutToDelete) {
                    //let workoutID = result.exerciseID
                
                    
                    
                    // Access core data context
                    let context = coreDataModel.persistentContainer.viewContext
            
                    self.results.remove(at: indexPath.row)
            
                    ResultsTableView.deleteRows(at: [indexPath], with: .automatic)
            
                    context.delete(results[indexPath.row])
            
                    coreDataModel.saveContext()
                    
                    
                    //ResultsTableView.reloadData()
                    
                    
                    
//                    let alert = UIAlertController(title: "Delete Workout", message: "Are you sure you want to delete Workout \(workoutID)?", preferredStyle: .actionSheet)
//                    
//                    let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteWorkout)
//                    
//                    let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteWorkout)
//                    
//                    alert.addAction(DeleteAction)
//                    alert.addAction(CancelAction)
//                    
//                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
//    func handleDeleteWorkout(alertAction: UIAlertAction!) -> Void {
//        
//        // Access core data context
//        let context = coreDataModel.persistentContainer.viewContext
//        
//        self.results.remove(at: (deleteWorkoutIndexPath?.row)!)
//        
//        ResultsTableView.deleteRows(at: [deleteWorkoutIndexPath as! IndexPath], with: .automatic)
//        
//        context.delete(results[(deleteWorkoutIndexPath!).row])
//        
//        coreDataModel.saveContext()
//        
//        print(deleteWorkoutIndexPath as! IndexPath)
//        
////        deleteWorkoutIndexPath = nil
//        
//        ResultsTableView.reloadData()
//    }
//    
//    func cancelDeleteWorkout(alertAction: UIAlertAction!) {
//        deleteWorkoutIndexPath = nil
//    }
}
