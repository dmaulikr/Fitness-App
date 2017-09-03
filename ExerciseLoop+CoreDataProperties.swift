//
//  ExerciseLoop+CoreDataProperties.swift
//  DigitalDash
//
//  Created by Nicholas Blackburn on 9/3/17.
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
    @NSManaged public var location: NSOrderedSet?

}

// MARK: Generated accessors for location
extension ExerciseLoop {

    @objc(insertObject:inLocationAtIndex:)
    @NSManaged public func insertIntoLocation(_ value: Location, at idx: Int)

    @objc(removeObjectFromLocationAtIndex:)
    @NSManaged public func removeFromLocation(at idx: Int)

    @objc(insertLocation:atIndexes:)
    @NSManaged public func insertIntoLocation(_ values: [Location], at indexes: NSIndexSet)

    @objc(removeLocationAtIndexes:)
    @NSManaged public func removeFromLocation(at indexes: NSIndexSet)

    @objc(replaceObjectInLocationAtIndex:withObject:)
    @NSManaged public func replaceLocation(at idx: Int, with value: Location)

    @objc(replaceLocationAtIndexes:withLocation:)
    @NSManaged public func replaceLocation(at indexes: NSIndexSet, with values: [Location])

    @objc(addLocationObject:)
    @NSManaged public func addToLocation(_ value: Location)

    @objc(removeLocationObject:)
    @NSManaged public func removeFromLocation(_ value: Location)

    @objc(addLocation:)
    @NSManaged public func addToLocation(_ values: NSOrderedSet)

    @objc(removeLocation:)
    @NSManaged public func removeFromLocation(_ values: NSOrderedSet)

}
