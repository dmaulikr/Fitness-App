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
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    lazy var coreDataArray = CoreDataArray()
    
    // Declare variable
    var results: [NSManagedObject] = []
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExerciseIDViewCell")
        //self.resultsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = coreDataModel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseLoop")
        
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
        //resultsTableView.reloadData()
    }
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ExerciseIDViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExerciseIDViewCell
        if cell == nil {
            cell = ExerciseIDViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        
        // Fetches the appropriate exercise loop for the data source layout.
        let result = results[indexPath.row]
        
        cell?.ExerciseIDLabel.text = String(describing: result.value(forKeyPath: "time")!) + " seconds"
        cell?.ExerciseIDSubtitle.text = result.value(forKeyPath: "date") as? String
        
        return cell!
        
    }

}

// Core data
//extension ResultsViewController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return coreDataArray.resultsArray.count
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//            
//            let cell =
//                tableView.dequeueReusableCell(withIdentifier: "Cell",
//                                              for: indexPath)
//            let cellText = "Exercise #" + "\(counter)"
//            cell.textLabel?.text = cellText
//            return cell
//    }
//}
