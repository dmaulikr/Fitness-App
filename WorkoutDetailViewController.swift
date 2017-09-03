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
import MapKit
import CoreLocation

class WorkoutDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // IBOutlet
    @IBOutlet weak var exerciseIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startHoursLabel: UILabel!
    @IBOutlet weak var endHoursLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepsLabel: CircleLabelView!
    @IBOutlet weak var distanceLabel: CircleLabelView!
    @IBOutlet weak var averageSpeedLabel: CircleLabelView!
    @IBOutlet weak var mapView: MKMapView!
    
    // Data model connection
    lazy var coreDataModel = CoreDataModel()
    
    // ExerciseLoop variable
    var exerciseLoop: ExerciseLoop!
    
    // Declare array to store entities as NSManagedObjects
    var results: [NSManagedObject] = []
    var result: NSManagedObject?
    var locations: NSMutableOrderedSet?
    var result1: NSManagedObject?
    //var locations: NSOrderedSet?
    
    
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
            
            
            //locations = NSOrderedSet(object: result!.value(forKeyPath: "location")!)
            
            locations = result?.mutableOrderedSetValue(forKeyPath: "location")
            
            for index in locations! {
                print("\((index as! Location).value(forKeyPath: "latitude"))")
            }
            
        } catch {
            fatalError("Failed to fetch exercise loops: \(error)")
        }
        
//        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Location")
//        let sortDescriptorDate1 = NSSortDescriptor(key: "time", ascending: false,
//                                                  selector: #selector(NSString.localizedStandardCompare))
//        fetchRequest1.sortDescriptors = [sortDescriptorDate1]
//        
//        // try to fetch ExerciseLoop context from data model and store in results array
//        do {
//            locations = try context.fetch(fetchRequest1) as! [Location]
//            
//            if (resultsToWorkoutDetail) {
//                result1 = self.locations[rowClicked!]
//                resultsToWorkoutDetail = false
//            }
//            else {
//                result1 = self.locations[0]
//            }
//            
//            for index in locations {
//                print("\(index)")
//            }
//           
//        } catch {
//            fatalError("Failed to fetch exercise loops: \(error)")
//        }

        // Start mapView updates
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.mapType = MKMapType.standard
        drawPolyline()
        
    }
    
    // Draw polyline
    func drawPolyline() {
//        var coordinates: [(CLLocation, CLLocation)] = []
//        
//        // 2
//        for (first, second) in zip(locations, locations.dropFirst()) {
//            var start: CLLocation? = nil
//            var end: CLLocation? = nil
//            start = CLLocation(latitude: first.latitude, longitude: first.longitude)
//            end = CLLocation(latitude: second.latitude, longitude: second.longitude)
//            coordinates.append((start!, end!))
//        }
//        
//        //5
//        var polylines: [MKPolyline] = []
//        for (start, end) in coordinates {
//            let coords = [start.coordinate, end.coordinate]
//            let polyline = MKPolyline(coordinates: coords, count: 2)
//            polylines.append(polyline)
//        }
//        return polylines
        
//        var coordinates: [(CLLocation, CLLocation)] = []
//        var start: CLLocation? = nil
//        var end: CLLocation? = nil
//        
//        if (locations != nil) {
//            for newLocation in locations! {
//                var index = (locations?.index(of: newLocation))!
//                if (index == 0) {
//                    continue
//                }
//                else {
//                    index -= 1
//                    let oldLocation = locations?.object(at: index)
//                    start = CLLocation(latitude: (oldLocation as! Location).latitude, longitude: (oldLocation as! Location).longitude)
//                    end = CLLocation(latitude: (newLocation as! Location).latitude, longitude: (newLocation as! Location).longitude)
//                    coordinates.append((start!, end!))
//                    let regionCoord = CLLocationCoordinate2DMake((oldLocation as! Location).latitude, (oldLocation as! Location).longitude)
//                    mapView.setRegion(MKCoordinateRegionMake(regionCoord, MKCoordinateSpanMake(0.01, 0.01)), animated: true)
//                    print("\(coordinates)")
//                }
//            }
//        }
//        
//        var polylines: [MKPolyline] = []
//        for (start, end) in coordinates {
//            let coords = [start.coordinate, end.coordinate]
//            let polyline = MKPolyline(coordinates: coords, count: 2)
//            polylines.append(polyline)
//        }
//        return polylines
        
        // Loop through locations
        for newLocation in locations! {
            // Set old location to the last location in array
            let index = locations?.index(of: newLocation)
            if (index! > 0) {
                let oldLocation = locations?[index! - 1]
                // Store coordinates of old and new location
                let oldLocationCoord = CLLocationCoordinate2D(latitude: (oldLocation as! Location).latitude, longitude: (oldLocation as! Location).longitude)
                let newLocationCoord = CLLocationCoordinate2D(latitude: (newLocation as! Location).latitude, longitude: (newLocation as! Location).longitude)
                let coordinates = [oldLocationCoord, newLocationCoord]
                mapView.setRegion(MKCoordinateRegionMake(oldLocationCoord, MKCoordinateSpanMake(0.01, 0.01)), animated: true)
                print("\(coordinates)")
                // Assign polyline to the coordinates
                let polyline = MKPolyline(coordinates: coordinates, count: 2)
                // Add polyline to the map view
                mapView.add(polyline)
            }
        }

    }
    
    //
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Overlay is a polyline
        if (overlay is MKPolyline) {
            // Draw polyline with renderer as red line
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // Convert timer from Int to String
    func timeToString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02d hours %02d minutes %02d seconds", hours, minutes, seconds)
    }
    
    // Home button tapped
    @IBAction func HomeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "WorkoutDetailToHome", sender: nil)
    }
    
    // Back button tapped
    @IBAction func BackTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "WorkoutDetailToResults", sender: nil)
    }
   
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Portrait mode only
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // Does not autorotate
    override var shouldAutorotate: Bool {
        return false
    }
}
