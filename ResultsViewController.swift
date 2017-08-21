//
//  ResultsViewController.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 8/20/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    @IBAction func ResultsToHomeButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ResultsToHome", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
