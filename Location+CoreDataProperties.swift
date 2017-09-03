//
//  Location+CoreDataProperties.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 9/3/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import CoreData


extension Location {
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var time: NSDate?
    @NSManaged public var exerciseLoop: ExerciseLoop?

}
