//
//  ExerciseLoop+CoreDataProperties.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 9/2/17.
//  Copyright © 2017 Nicholas Blackburn. All rights reserved.
//

import Foundation
import CoreData


extension ExerciseLoop {

    @NSManaged public var averageSpeed: String?
    @NSManaged public var date: String?
    @NSManaged public var dateShort: String?
    @NSManaged public var distance: String?
    @NSManaged public var endHours: String?
    @NSManaged public var exerciseID: Int16
    @NSManaged public var startHours: String?
    @NSManaged public var steps: String?
    @NSManaged public var time: Int16
    @NSManaged public var location: Location?

}
