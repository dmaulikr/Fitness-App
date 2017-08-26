//
//  WorkoutDetailViewController.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 8/26/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import UIKit

class WorkoutDetailViewController: UIViewController {
    
    
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
