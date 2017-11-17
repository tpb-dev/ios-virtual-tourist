//
//  CollectionImage+CoreDataProperties.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/16/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//
//

import Foundation
import CoreData


extension CollectionImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionImage> {
        return NSFetchRequest<CollectionImage>(entityName: "CollectionImage")
    }

    @NSManaged public var imgURL: String?
    @NSManaged public var pinID: String?
    @NSManaged public var parentPin: Pin?

}
