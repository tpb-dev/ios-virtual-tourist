//
//  MapController.swift
//  ios-virtual-tourist
//
//  Created by Randall Tom on 11/17/17.
//  Copyright © 2017 tpb-dev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MapController {
    
    static let instance = MapController()
    
    func storePinInstance(longitude: Double, latitude: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Pin",
                                       in: managedContext)!
        
        let pin = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        pin.setValue(longitude, forKeyPath: "longitude")
        pin.setValue(latitude, forKeyPath: "latitude")
        
        do {
            try managedContext.save()
            appDelegate.pins.append(pin)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
}
