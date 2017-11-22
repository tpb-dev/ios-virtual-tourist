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
    
    var currentCoordinatesLongitude : Double = 0.0
    var currentCoordinatesLatitude : Double = 0.0
    
    func storePinInstance(longitude: Double, latitude: Double) -> Pin? {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Pin",
                                       in: managedContext)!
        
        let pin = Pin(entity: entity,
                                     insertInto: managedContext)
        
        pin.setValue(longitude, forKeyPath: "longitude")
        pin.setValue(latitude, forKeyPath: "latitude")
        
        do {
            try managedContext.save()
            appDelegate.pins.append(pin)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return pin
        
    }
    
    func getAllPins() -> [Pin]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let pinsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let fetchedPins = try managedContext.fetch(pinsFetch) as! [Pin]
            return fetchedPins
        } catch {
            fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
}
