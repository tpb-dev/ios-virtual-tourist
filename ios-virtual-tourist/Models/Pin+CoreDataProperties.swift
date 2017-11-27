//
//  Pin+CoreDataProperties.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/27/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var imgs: NSSet?

}

// MARK: Generated accessors for imgs
extension Pin {

    @objc(addImgsObject:)
    @NSManaged public func addToImgs(_ value: CollectionImage)

    @objc(removeImgsObject:)
    @NSManaged public func removeFromImgs(_ value: CollectionImage)

    @objc(addImgs:)
    @NSManaged public func addToImgs(_ values: NSSet)

    @objc(removeImgs:)
    @NSManaged public func removeFromImgs(_ values: NSSet)

}
